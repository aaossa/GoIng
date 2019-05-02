class Request < ApplicationRecord
	belongs_to :user
	belongs_to :course
	belongs_to :confirmed_class, optional: true
	has_and_belongs_to_many :preferences, index_errors: true

	validate :participants_hash_is_valid
	validate :participants_emails_are_valid
	validates :priority, numericality: { greater_than: 0 }
	validates :contents, presence: true, length: { minimum: 5 }
	validates_associated :preferences
	validate :teaching_assistant_available
	accepts_nested_attributes_for :preferences

	serialize :participants, Hash
    before_save(on: :create) do
        self.participants["0"] = user.google_email
    end
    after_create :send_mail_to_participants

    def self.inactive
    	where(active: false).where(assigned: false).where(completed: false)
    end

    def self.group_by_course_and_participants(requests)
    	result = requests.group_by(&:course_id).map do |course_id, course_requests|
    		course = Course.find(course_id)
    		grouped_requests = form_groups(course_requests.group_by { |r| r.participants.length })
    		[course, grouped_requests]
    	end
    	result.to_h
    end

    def participants_mails
    	self.participants.sort.to_h.values.reject { |p| p.empty? }
    end

	def display_request
		"#{course.name}: #{contents} (#{preferences.map(&:display_preference).as_json})"
	end

	protected

	    def send_mail_to_participants
	    	RequestMailer.confirm_request_creation(self).deliver_later
	    end

		def self.group_by_participantso(requests)
			requests = requests.group_by { |r| r.participants.length }
			form_groups(requests)
		end

		def self.form_groups(requests_by_participants)
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
			while requests_2.length + requests_1.length != 0 do
				final_groups << [requests_2.slice!(0), requests_1.slice!(0), requests_1.slice!(0)].compact
				final_groups << [requests_2.slice!(0), requests_2.slice!(0)].compact
			end
			# Return
			final_groups = final_groups.reject { |g| g.empty? }
			# Sort groups by accumulated (squared) priority
			final_groups.sort_by { |g| g.map {|e| e.priority ** 2}.sum }.reverse
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
