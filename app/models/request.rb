class Request < ApplicationRecord
	belongs_to :user
	belongs_to :course
	belongs_to :confirmed_class, optional: true
	has_and_belongs_to_many :preferences, index_errors: true

	validates :participants, presence: true, inclusion: 1..4
	validates :contents, presence: true, length: { minimum: 5 }
	validates_associated :preferences
	validate :teaching_assistant_available
	accepts_nested_attributes_for :preferences

	def teaching_assistant_available
		preferences.each do |preference|
			next if preference.time_block.available_courses.include? course
			errors.add(:course, "not available this time block")
		end 
	end

	def display_request
		prefs = preferences.map(&:display_preference).as_json
		"#{course.name}: #{contents} (#{prefs})"
	end
end
