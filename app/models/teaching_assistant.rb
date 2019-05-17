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
	after_create :check_if_teaching_assistant_is_user
	after_destroy :switch_back_teaching_assistant_to_user

	def self.order_by_name
		order(name: :asc)
	end

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

	protected

		def check_if_teaching_assistant_is_user
			ta_as_user = User.find_by(google_email: self.email)
			return if ta_as_user.nil?
			ta_as_user.update(role: :teaching_assistant)
		end

		def switch_back_teaching_assistant_to_user
			ta_as_user = User.find_by(google_email: self.email)
			return if ta_as_user.nil?
			ta_as_user.update(role: :student)
		end
end
