class TeachingAssistant < ApplicationRecord
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
end
