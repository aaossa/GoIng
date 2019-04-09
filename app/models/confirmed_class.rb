class ConfirmedClass < ApplicationRecord
	belongs_to :teaching_assistant
	belongs_to :preference
	has_many :requests

	validate :requests_match_time_block
	validate :requests_match_course
	validate :teaching_assistant_match_time_block
	validates :preference_id, uniqueness: { scope: :teaching_assistant_id }

	after_create :send_email_to_teaching_assistant

	def send_email_to_teaching_assistant
		# TODO: Enviar mail a ayudante preguntando yes/no
	end

	private

		def requests_match_time_block
			requests.each do |request|
				next if request.preferences.any? { |p| preference.time_block == p.time_block }
				errors.add(:preference, "does not match one of the requests")
			end 
		end

		def requests_match_course
			courses = requests.map(&:course).uniq
			unless courses.size == 1
				errors.add(:requests, "do not match courses between them")
				return
			end
			unless teaching_assistant.courses.include? courses.first
				errors.add(:requests, "do not match teaching assistant courses")
			end
		end

		def teaching_assistant_match_time_block
			return if teaching_assistant.time_blocks.any? do |time_block|
				time_block == preference.time_block
			end
			errors.add(:teaching_assistant, "does not have this time block available")
		end

end
