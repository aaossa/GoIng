class Request < ApplicationRecord
	belongs_to :user
	belongs_to :course
	belongs_to :confirmed_class, optional: true
	has_and_belongs_to_many :preferences, index_errors: true

	validate :participants_hash_is_valid
	validate :participants_emails_are_valid
	validates :priority, inclusion: 1..3
	validates :contents, presence: true, length: { minimum: 5 }
	validates_associated :preferences
	validate :teaching_assistant_available
	accepts_nested_attributes_for :preferences

	serialize :participants, Hash
    before_save(on: :create) do
        self.participants["0"] = user.google_email
    end

    def participants_mails
    	self.participants.sort.to_h.values.reject { |p| p.empty? }
    end

	def display_request
		"#{course.name}: #{contents} (#{preferences.map(&:display_preference).as_json})"
	end

	private

		def participants_hash_is_valid
			valid_keys = ["0", "1", "2", "3"]
			unless (participants.keys - valid_keys).empty?
				errors.add(:participants, "invalid keys")
			end
		end

		def participants_emails_are_valid
			usernames = []
			participants.each do |position, email|
				next if email.empty?
				usernames << email.split("@").first
				next if email.match("^[^@]+@(uc\.cl|correo\.puc\.cl|puc\.cl)$")
				errors.add(:participants, "invalid email")
			end
			unless usernames.uniq.length == usernames.length
				errors.add(:participants, "should not contain duplicates")
			end
		end

		def teaching_assistant_available
			preferences.each do |preference|
				next if preference.time_block.available_courses.include? course
				errors.add(:course, "not available this time block")
			end 
		end
end
