class Request < ApplicationRecord
	belongs_to :user
	belongs_to :course
	has_many :preferences, index_errors: true

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
end
