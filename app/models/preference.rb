class Preference < ApplicationRecord
	belongs_to :time_block
	has_many :confirmed_classes
	has_and_belongs_to_many :requests
	has_and_belongs_to_many :unavailable_tas,
							class_name: "TeachingAssistant",
							join_table: "preferences_teaching_assistants",
							foreign_key: "teaching_assistant_id",
							association_foreign_key: "preference_id"

	validates :date, presence: true
	validates :date, uniqueness: { scope: :time_block_id }
	validate :date_block_match

	scope :active, -> { where("date BETWEEN ? AND ?", Time.current.to_date, Time.current.to_date + 1.week) }
	scope :recent, -> { includes(:time_block).order(date: :asc, start: :asc) }

	def self.create_classes
		Preference.active.recent.map(&:create_classes)
	end

	def create_classes
		# Filtrar solicitudes procesables
		@requests = self.requests.inactive
		# Agrupar solicitudes por curso y cantidad de participantes
		@groups_per_course = Request.group_by_course_and_participants(@requests)
		@groups_per_course.each do |course, groups|
			# Filtrar ayudantes disponibles
			@available_TAs = TeachingAssistant.unassigned_at(course, self)
			groups.each do |group|
				# Elegir el siguiente ayudante disponible
				teaching_assistant = @available_TAs.shift
				if teaching_assistant.nil?
					# Si no quedan, la prioridad aumenta en uno
					Request.update_counters(group, priority: 1)
					next
				end
				# Si quedan, creo la clase
				ConfirmedClass.create(
					teaching_assistant: teaching_assistant,
					preference: self,
					requests: group,
				)
				# Ayudante se marca como ocupado
				next if self.unavailable_tas.include?(teaching_assistant)
				self.unavailable_tas << teaching_assistant
			end
		end
		# Retorno las clases de esta preferencia
		self.confirmed_classes
	end

	def display_preference
		d = date.strftime("%d/%m/%y")
		"#{d} #{time_block.display_block}"
	end

	def candidates(course)
		course.teaching_assistants.joins(:time_blocks).where(time_blocks: {id: time_block.id})
	end

	private

		def date_block_match
			if time_block.day != date.wday
				errors.add(:date, "mismatch time block selection")
		    end
		end

end
