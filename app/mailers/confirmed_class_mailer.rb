class ConfirmedClassMailer < ApplicationMailer
	default 'Content-Transfer-Encoding': '7bit'

	def created_class_email_to_teaching_assistant
		# Email to ask TAs for a CC
		@confirmed_class = params[:confirmed_class]
		teaching_assistant = @confirmed_class.teaching_assistant
		m = mail(
			to: teaching_assistant.email,
			subject: "[GoIng] Clase asignada",
			content_type: "text/html",
		)
		m.transport_encoding = "base64"
		m.deliver
	end

	def confirmed_class_email_to_participant
		# Email to notify students of a CC
		@confirmed_class = params[:confirmed_class]
		m = mail(
			to: "aaossa@uc.cl", # TODO: Cambiar por estudiantes
			subject: "[GoIng] Confirma tu clase!",
			content_type: "text/html",
		)
		m.transport_encoding = "base64"
		m.deliver
	end

	def classmates_email_to_participant
		# Email to notify a new confirmed participant of a CC
		@confirmed_class = params[:confirmed_class]
		m = mail(
			to: "aaossa@uc.cl", # TODO: Cambiar por estudiantes
			subject: "[GoIng] Compañeros de clase",
			content_type: "text/html",
		)
		m.transport_encoding = "base64"
		m.deliver	

end
