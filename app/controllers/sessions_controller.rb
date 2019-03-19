class SessionsController < ApplicationController
	def create
		auth = request.env['omniauth.auth']
		unless @auth = Identity.find_from_hash(auth)
			# Create a new user or add an auth to existing user, depending on
			# whether there ir already a user signed in
			@auth = Identity.create_from_hash(auth, current_user)
		end
		# Log the authorizing user in
		self.current_user = @auth.user

		redirect_to root_url, notice: "Signed in, #{current_user.google_email}! "
	end

	def destroy
		self.current_user = nil
		redirect_to root_url, notice: "Signed out!"
	end
end
