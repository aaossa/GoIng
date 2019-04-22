class ConfirmedClassesController < ApplicationController
  before_action :set_confirmed_class, only: [:show, :edit, :update, :destroy]

  def answer_teaching_assistant_yes
    @confirmed_class = ConfirmedClass.find(params[:confirmed_class_id])
    # Clase exitosamente asignada -> Se envia correo a alumnos desde modelo
    @confirmed_class.update(assigned: true)
  end

  # TODO: Definir algoritmo si el ayudante dice que no
  def answer_teaching_assistant_no
    @confirmed_class = ConfirmedClass.find(params[:confirmed_class_id])
    # Marcar clases como inactivas y eliminar CC
    @confirmed_class.requests.update_all(active: false)
    @confirmed_class.destroy
    # TODO: Si hay más ayudantes en esta preferencia, crear ConfirmedClass y enviar mail a TA
    # TODO: SI no hay más ayudantes en esta preferencia, marcar como no procesada
    # request.active = false
    # TODO: Si no hay más ayudantes en esta preferencia, subir prioridad a request
    # request.priority += 1
    # request.save
    # Recorrer las preferencias de una request en orden
  end

  # TODO: Que pasa si el alumno dice que si
  def answer_student_yes
  end

  # TODO: Que pasa si el alumno dice que no
  def answer_student_no
  end

  # GET /confirmed_classes
  # GET /confirmed_classes.json
  def index
    @confirmed_classes = ConfirmedClass.all
  end

  # GET /confirmed_classes/1
  # GET /confirmed_classes/1.json
  def show
  end

  # GET /confirmed_classes/new
  def new
    @confirmed_class = ConfirmedClass.new
  end

  # GET /confirmed_classes/1/edit
  def edit
  end

  # POST /confirmed_classes
  # POST /confirmed_classes.json
  def create
    @confirmed_class = ConfirmedClass.new(confirmed_class_params)

    respond_to do |format|
      if @confirmed_class.save
        format.html { redirect_to @confirmed_class, notice: 'Confirmed class was successfully created.' }
        format.json { render :show, status: :created, location: @confirmed_class }
      else
        format.html { render :new }
        format.json { render json: @confirmed_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /confirmed_classes/1
  # PATCH/PUT /confirmed_classes/1.json
  def update
    respond_to do |format|
      if @confirmed_class.update(confirmed_class_params)
        format.html { redirect_to @confirmed_class, notice: 'Confirmed class was successfully updated.' }
        format.json { render :show, status: :ok, location: @confirmed_class }
      else
        format.html { render :edit }
        format.json { render json: @confirmed_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /confirmed_classes/1
  # DELETE /confirmed_classes/1.json
  def destroy
    @confirmed_class.destroy
    respond_to do |format|
      format.html { redirect_to confirmed_classes_url, notice: 'Confirmed class was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_confirmed_class
      @confirmed_class = ConfirmedClass.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def confirmed_class_params
      params.require(:confirmed_class).permit(:teaching_assistant_id, :preference_id, request_ids: [])
    end
end
