class User < ApplicationRecord
	has_one :identity
	has_many :requests

	validates_presence_of :google_name
	validates_presence_of :google_email
	validates_presence_of :google_image
	validates_presence_of :google_token

	validates_inclusion_of :role, in: %i[admin teaching_assistant student]

	after_create :check_if_user_is_teaching_assistant

	def role
		self.attributes['role'].to_sym
	end

	def role?(r)
		self.role == r
	end

	def self.create_from_hash!(hash)
		create(User.google_attributes(hash))
	end

	def update_from_hash!(hash)
		update(User.google_attributes(hash))
	end

	protected

		def check_if_user_is_teaching_assistant
			user_as_ta = TeachingAssistant.find_by(email: self.google_email)
			return if user_as_ta.nil?
			self.role = :teaching_assistant
		end

	private

		def self.google_attributes(hash)
			{
				:google_name => hash['info']['name'],
				:google_email => hash['info']['email'],
				:google_image => hash['info']['image'],
				:google_token => hash['credentials']['token']
			}
		end
end
