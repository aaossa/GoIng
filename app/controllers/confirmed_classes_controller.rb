class ConfirmedClassesController < ApplicationController
  load_and_authorize_resource
  before_action :set_confirmed_class, only: [:show, :edit, :update, :destroy]

  def answer_teaching_assistant_yes
    @confirmed_class = ConfirmedClass.find(params[:confirmed_class_id])
    # Clase exitosamente asignada -> Se envia correo a alumnos desde modelo
    @confirmed_class.update(assigned: true)
    redirect_to(@confirmed_class)
  end

  def answer_teaching_assistant_no
    @confirmed_class = ConfirmedClass.find(params[:confirmed_class_id])
    # Clase no pudo asignarse -> Se busca un nuevo ayudante desde modelo
    @confirmed_class.destroy
    redirect_to(controller: 'welcome', action: 'index')
  end

  def answer_student_yes
    @confirmed_class = ConfirmedClass.find(params[:confirmed_class_id])
    # Clase confirmada -> Se le avisa a ayudante desde modelo
    @confirmed_class.update(confirmed: true)
    redirect_to(@confirmed_class)
  end

  def answer_student_no
    @confirmed_class = ConfirmedClass.find(params[:confirmed_class_id])
    # Actualizar contador o usar flash para mostrar el estado actual
    redirect_to(@confirmed_class)
  end

  # GET /confirmed_classes
  # GET /confirmed_classes.json
  def index
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
