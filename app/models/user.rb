class User < ApplicationRecord
	has_one :identity
	has_many :requests

	ROLES = %i[admin teaching_assitant student]

	def role?(role)
		self.role == role
	end

	def self.create_from_hash!(hash)
		create(User.google_attributes(hash))
	end

	def update_from_hash!(hash)
		update(User.google_attributes(hash))
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
