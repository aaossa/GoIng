class Course < ApplicationRecord
	has_many :requests
	validates :name, presence: true, length: { minimum: 5 }
end
