class TeachingAssistant < ApplicationRecord
  	has_many :confirmed_classes
  	has_and_belongs_to_many :courses
  	has_and_belongs_to_many :time_blocks
	has_and_belongs_to_many :unavailable_preferences,
							class_name: "Preference",
							join_table: "preferences_teaching_assistants",
							foreign_key: "preference_id",
							association_foreign_key: "teaching_assistant_id"
  	validates :name, presence: true, length: { minimum: 5 }
	validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
	validates :phone_number, presence: true, numericality: true, length: { minimum: 8, maximum: 12 }

	def self.unassigned_at(course, preference)
		# TAs of this course with this time block available
	    a = course.teaching_assistants
	    b = preference.time_block.teaching_assistants
	    c = a & b
	    # Remove TAs with this preference not available
	    d = preference.unavailable_tas
	    e = c - d | d - c
	    # Sort TAs according to their assigned classes
	    f = self.left_joins(:confirmed_classes).group(:id).order(Arel.sql("COUNT(confirmed_classes.id) ASC"))
	    g = f & a
	    # Final list
	    h = g & e
	end
end
