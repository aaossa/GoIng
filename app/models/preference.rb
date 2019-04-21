class Preference < ApplicationRecord
	belongs_to :time_block
	has_and_belongs_to_many :requests
	has_and_belongs_to_many :unavailable_tas,
							class_name: "TeachingAssistant",
							join_table: "preferences_teaching_assistants",
							foreign_key: "teaching_assistant_id",
							association_foreign_key: "preference_id"
	validates :date, presence: true
	validates :date, uniqueness: { scope: :time_block_id }
	validate :date_block_match
	default_scope { order(date: :asc) }
	# Ordenando las preferencias de la más temprana a la más lejana
	# Habría que llamarlo cuando falte una semana para cada modulo/dia
	# Preference.includes(:time_block).order(date: :asc, start: :asc)

	# Convertir a class method?
	def create_classes
	    # CLASSMETHOD TODO: Iterar sobre cada o en un rango (quizas las de un mismo dia)
	    # CLASSMETHOD @preference = Preference.includes(:time_block).order(date: :asc, start: :asc).first
	    @preference = self
	    # Ordeno las requests por prioridad
	    requests = @preference.requests.order(priority: :desc)
	    # Ignoro las requests ya reservadas o en proceso
	    # TO DO: Ignoro las active: true?
	    requests = requests.where(active: false).where(assigned: false).where(completed: false)
	    # Ordeno las requests agrupadas por curso y por participantes
	    requests = requests.group_by(&:course_id).map {|k, v| [k, v.group_by { |r| r.participants.length } ]}.to_h
	    # Formo los grupos en 'group_requests'
	    @groups_per_course = requests.map {|k, v| [k, group_requests(v)]}.to_h
	    # Para cada grupo formado
	    @groups_per_course.each do |course, groups|
	    	# Obtengo el curso en base al id
	    	course = Course.find course
	    	# Obtenemos los ayudantes disponibles de este curso para este módulo
	    	# Ordenados por clases hechas (menos a mas)
	    	available_tas = @preference.available_teaching_assistants(course)
	    	groups.each do |group|
	    		puts "\tGroup: #{group.map(&:participants)}"
	    		group.each do |r|
	    			puts "\t\t>> #{r.course.name}"
	    		end
	    		teaching_assistant = available_tas.shift
	    		if teaching_assistant.nil?
	    			# Si se acaban los ayudantes, se sube la prioridad a las requests
	    			# de los grupos y se pasa a la siguiente preferencia
	    			group.each do |request|
	    				puts "\t>> Request #{request}"
	    				puts "\t>> Request priority #{request.priority}"
	    				if request.priority < 3
	    					request.increment(:priority)
	    					request.save
	    				else
	    					puts "\t>> ALERTA REQUEST NO ATENDIDA"
	    				end
	    				puts "\t>> Request errors #{request.errors.full_messages}"
	    				# Si una request llega a priority 4 es porque no puedo asignarle
	    				# a nadie, que hago aqui?
	    			end
	    			break
	    		end
	    		# Crear clase confirmada
	    		cc = ConfirmedClass.new
	    		cc.teaching_assistant = teaching_assistant
	    		cc.preference = self
	    		cc.requests = group
	    		cc.save
			    # Marco ayudante como ocupado este modulo (independiente de su respuesta)
	    		@preference.unavailable_tas << teaching_assistant unless @preference.unavailable_tas.include?(teaching_assistant)
	    	end
	    end
	end

	def display_preference
		d = date.strftime("%d/%m/%y")
		"#{d} #{time_block.display_block}"
	end

	def candidates(course)
		course.teaching_assistants.joins(:time_blocks).where(time_blocks: {id: time_block.id})
	end

	protected

		def available_teaching_assistants(course)
			# TAs of this course with this time block available
	    	a = course.teaching_assistants
	    	b = time_block.teaching_assistants
	    	c = a & b
	    	# Remove TAs with this preference not available
	    	d = self.unavailable_tas
	    	e = c - d | d - c
	    	# Sort TAs according to their assigned classes
	    	f = TeachingAssistant.left_joins(:confirmed_classes).group(:id).order("COUNT(confirmed_classes.id) ASC")
	    	g = f & a
	    	# Final list
	    	h = g & e
		end

	private

		def date_block_match
			if time_block.day != date.wday
				errors.add(:date, "mismatch time block selection")
		    end
		end

		def group_requests(requests_by_participants)
			# Full groups
			requests_4 = requests_by_participants.fetch(4, [])
			final_groups = requests_4.map {|r| [r]}
			# 3s with 1s
			requests_3 = requests_by_participants.fetch(3, [])
			requests_1 = requests_by_participants.fetch(1, [])
			[requests_3.length, requests_1.length].min.times do
				final_groups << [requests_3.slice!(0), requests_1.slice!(0)]
			end
			final_groups.push(*requests_3.from(requests_1.length).map {|r| [r]})
			# 2s and 2s, 2s and 1s
			requests_2 = requests_by_participants.fetch(2, [])
			i = 0
			while requests_2.length + requests_1.length != 0 do
				if i.even?
					final_groups << [requests_2.slice!(0), requests_1.slice!(0), requests_1.slice!(0)].compact
				else
					final_groups << [requests_2.slice!(0), requests_2.slice!(0)].compact
				end
				i += 1
			end
			# Return
			final_groups
		end
end
