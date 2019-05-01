class ConfirmedClassMailer < ApplicationMailer
	default 'Content-Transfer-Encoding': '7bit'

	def ask_teaching_assistant(confirmed_class)
		# Email to ask TAs for a CC
		@confirmed_class = confirmed_class
		teaching_assistant = @confirmed_class.teaching_assistant
		m = mail(
			to: teaching_assistant.email,
			subject: "[GoIng] Clase asignada",
			content_type: "text/html",
		)
		m.transport_encoding = "base64"
		m.deliver
	end

	def confirm_class_to_participants(confirmed_class)
		# Email to notify students of a CC
		@confirmed_class = confirmed_class
		mails = @confirmed_class.requests.map(&:participants_mails).flatten(1)
		mails.each do |mail|
			m = mail(
				to: mail,
				subject: "[GoIng] Confirma tu clase!",
				content_type: "text/html",
			)
			m.transport_encoding = "base64"
			m.deliver
		end
	end

	# def classmates_email_to_participant
	# 	# Email to notify a new confirmed participant of a CC
	# 	@confirmed_class = params[:confirmed_class]
	# 	m = mail(
	# 		to: "aaossa@uc.cl", # TODO: Cambiar por estudiantes
	# 		subject: "[GoIng] Compañeros de clase",
	# 		content_type: "text/html",
	# 	)
	# 	m.transport_encoding = "base64"
	# 	m.deliver
	# end

end
