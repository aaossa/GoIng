Rails.application.config.middleware.use OmniAuth::Builder do
	provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
	{
		name: 'google',
		prompt: 'select_account',
		hd: 'uc.cl',
		skip_jwt: true,
		verify_iss: false
	}
	OmniAuth.config.allowed_request_methods = [:post, :get]
end