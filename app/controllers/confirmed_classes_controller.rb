class ConfirmedClassesController < ApplicationController
  load_and_authorize_resource
  before_action :set_confirmed_class_with_slug, only: [
    :answer_teaching_assistant_yes,
    :answer_teaching_assistant_no,
    :answer_student_yes,
    :answer_student_no,
    :show,
    :destroy,
  ]

  # GET /clases/:id_slug/ayudantes/si
  def answer_teaching_assistant_yes
    # Clase exitosamente asignada -> Se envia correo a alumnos desde modelo
    @confirmed_class.update(assigned: true)
    redirect_to(@confirmed_class)
  end

  # GET /clases/:id_slug/ayudantes/no
  def answer_teaching_assistant_no
    # Clase no pudo asignarse -> Se busca un nuevo ayudante desde modelo
    @confirmed_class.destroy
    redirect_to(controller: 'welcome', action: 'index')
  end

  # GET /clases/:id_slug/alumnos/si
  def answer_student_yes
    # Clase confirmada -> Se le avisa a ayudante desde modelo
    @confirmed_class.update(confirmed: true)
    redirect_to(@confirmed_class)
  end

  # GET /clases/:id_slug/alumnos/no
  def answer_student_no
    # Actualizar contador o usar flash para mostrar el estado actual
    redirect_to(@confirmed_class)
  end

  # GET /clases
  def index
  end

  # GET /clases/:id_slug
  def show
    @teaching_assistant = @confirmed_class.teaching_assistant
  end

  # GET /clases/new
  def new
    @confirmed_class = ConfirmedClass.new
  end

  # DELETE /clases/:id_slug
  def destroy
    @confirmed_class.destroy
    redirect_to confirmed_classes_path
  end

  private
    # # Use callbacks to share common setup or constraints between actions.
    def set_confirmed_class_with_slug
      id, slug = Array.new(2).zip(params[:id_slug].split('-', 2)).transpose.last
      # Use bang version to raise RecordNotFound if needed
      @confirmed_class = ConfirmedClass.find_by!(id: id, slug: slug)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def confirmed_class_params
      params.require(:confirmed_class).permit(:teaching_assistant_id, :preference_id, request_ids: [])
    end
end
