class RequestMailer < ApplicationMailer
	default 'Content-Transfer-Encoding': '7bit'

	def confirm_request_creation(request)
		# Email to notify students about request creation
		@request = request
		m = mail(
			to: request.participants,
			subject: "[GoIng] Clase recibida",
			content_type: "text/html",
		)
		m.transport_encoding = "base64"
		m.deliver
	end

	def remind_inactive(request)
		# Email to notify students about a request that is over 2 days old
		@request = request
		m = mail(
			to: request.participants,
			subject: "[GoIng] Tu solicitud de clase lleva esperando más de 2 días",
			content_type: "text/html",
		)
		m.transport_encoding = "base64"
		m.deliver
end
