class ConfirmedClassMailer < ApplicationMailer

	def created_class_email
		@teaching_assistant = params[:teaching_assistant]
		mail(to: @teaching_assistant.email, subject: "[GoIng] Clase asignada")
	end

end
