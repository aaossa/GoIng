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
	    requests = @preference.requests.order_by(priority: :desc)
	    # Ignoro las requests ya reservadas o en proceso
	    requests = requests.where(active: false)
	    # Ordeno las requests agrupadas por curso y por participantes
	    requests = requests.group_by(&:course_id).map {|k, v| [k, v.group_by(&:participants) ]}.to_h
	    # Formo los grupos en 'group_requests'
	    @groups = requests.map {|k, v| [k, group_requests(v)]}.to_h
	    # Para cada grupo formado
	    @groups.each do |course, groups|
	    	# Obtengo el curso en base al id
	    	course = Course.find course
	    	puts "Course: #{course.name}"
	    	# Obtenemos los ayudantes disponibles de este curso para este módulo
	    	available_tas = @preference.available_teaching_assistants(course)
	    	# TODO: Filtrar los que están disponibles esta preferencia (quizás crear una tabla intermedia entre TA y Preferencia)
	    	# TODO: Ordenar por clases hechas (menos a mas)
	    	groups.each do |group|
	    		puts "\tGroup: #{group.map(&:participants)}"
	    		cc = ConfirmedClass.new
	    		cc.teaching_assistant = @teaching_assistants.first # IR AVANZANDO EN LA LISTA, SI SE ME ACABAN LOS AYUDANTES DEBO SUBIRLE LA PRIORIDAD A AMBOS GRUPOS Y PASAR A LA SIGUIENTE PREFERENCIA
	    		cc.preference = self
	    		cc.requests = group
	    		cc.save
	    		puts "\t#{cc.errors.full_messages}"
			    # TODO: Marcar ayudante como ocupado este modulo (independiente de su respuesta)
	    	end
	    	puts ""
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
			# TODO: Filtrar los que están disponibles esta preferencia (quizás crear una tabla intermedia entre TA y Preferencia)
	    	# TODO: Ordenar por clases hechas (menos a mas)
	    	# @teaching_assistants.includes(:courses).where(courses: {id: request.course_id})
	    	a = course.teaching_assistants
	    	b = time_block.teaching_assistants
	    	c = a & b
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
