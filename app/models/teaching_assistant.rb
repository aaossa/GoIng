class TeachingAssistant < ApplicationRecord
	validates :name, presence: true, length: { minimum: 5 }
	validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
	validates :phone_number, presence: true, numericality: true, length: { minimum: 8, maximum: 12 }
end
