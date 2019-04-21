class ConfirmedClass < ApplicationRecord
	belongs_to :teaching_assistant
	belongs_to :preference
	has_many :requests

	validate :requests_are_not_completed_or_assigned, on: :create
	validate :requests_match_course
	validate :requests_match_time_block
	validate :teaching_assistant_match_time_block
	validates :preference_id, uniqueness: { scope: :teaching_assistant_id }

    before_validation :mark_requests_as_active, on: :create
	after_save :mark_requests_as_assigned, if: :will_save_change_to_assigned?
	after_save :send_email_to_participants, if: :will_save_change_to_assigned?
	after_create :send_email_to_teaching_assistant

    def course
        self.requests.first.course
    end

	protected

		def send_email_to_teaching_assistant
			ConfirmedClassMailer.ask_teaching_assistant(self).deliver_now
		end

		def send_email_to_participants
			ConfirmedClassMailer.confirm_class_to_participants(self).deliver_later
		end

	private

		def mark_requests_as_active
			requests.each do |r|
				r.active = true
				r.save
			end
		end

		def mark_requests_as_assigned
			return unless self.assigned
			requests.update_all(assigned: true)
		end

		def requests_are_not_completed_or_assigned
			all_active = requests.map(&:active).all?
			any_assigned = requests.map(&:assigned).any?
			any_completed = requests.map(&:completed).any?
			unless all_active && !any_assigned && !any_completed
				errors.add(:requests, "have not the right status (active, not assigned, not completed)")
			end
		end

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
