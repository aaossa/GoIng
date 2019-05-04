class ConfirmedClassMailer < ApplicationMailer
	default 'Content-Transfer-Encoding': '7bit'

	def ask_teaching_assistant(confirmed_class)
		# Email to ask TAs for a CC
		@confirmed_class = confirmed_class
		@teaching_assistant = @confirmed_class.teaching_assistant
		m = mail(
			to: @teaching_assistant.email,
			subject: "[GoIng] Clase asignada",
			content_type: "text/html",
		)
		m.transport_encoding = "base64"
		m.deliver
	end

	def confirm_class_to_participants(confirmed_class)
		# Email to notify students of a CC
		@confirmed_class = confirmed_class
		m = mail(
			to: @confirmed_class.participants_mails,
			subject: "[GoIng] Clase aceptada!",
			content_type: "text/html",
		)
		m.transport_encoding = "base64"
		m.deliver
	end

	def confirm_class_to_teaching_assistant(confirmed_class)
		# Email to confirm CC to TA
		@confirmed_class = confirmed_class
		@teaching_assistant = @confirmed_class.teaching_assistant
		m = mail(
			to: @teaching_assistant.email,
			subject: "[GoIng] Clase confirmada",
			content_type: "text/html",
		)
		m.transport_encoding = "base64"
		m.deliver
	end

end
