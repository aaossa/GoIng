class RequestMailer < ApplicationMailer

	def request_email
		@confirmed_class = params[:confirmed_class]
		@teaching_assistant = @confirmed_class.teaching_assistant
		@preference = @confirmed_class.preference
		@course = @confirmed_class.course
		@url = "http://127.0.0.1:3000/"
		mail(to: @teaching_assistant.email, subject: "New request!")
	end
end
