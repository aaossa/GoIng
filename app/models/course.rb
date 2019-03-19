class Course < ApplicationRecord
	has_many :requests
  	has_and_belongs_to_many :teaching_assistants
	validates :name, presence: true, length: { minimum: 5 }
end
