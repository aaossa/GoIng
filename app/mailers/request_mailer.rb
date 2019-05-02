class RequestMailer < ApplicationMailer
	default 'Content-Transfer-Encoding': '7bit'

	def confirm_request_creation(request)
		# Email to notify students about request creation
		@request = request
		m = mail(
			to: request.participants.values,
			subject: "[GoIng] Clase recibida",
			content_type: "text/html",
		)
		m.transport_encoding = "base64"
		m.deliver
	end
end
