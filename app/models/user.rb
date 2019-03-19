class User < ApplicationRecord
	has_one :identity

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
