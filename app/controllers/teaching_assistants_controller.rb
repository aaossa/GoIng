class TeachingAssistantsController < ApplicationController
  load_and_authorize_resource

  before_action :set_teaching_assistant, only: [:show, :edit, :update, :destroy]

  # GET /teaching_assistants
  # GET /teaching_assistants.json
  def index
    @teaching_assistants = TeachingAssistant.all
  end

  # GET /teaching_assistants/1
  # GET /teaching_assistants/1.json
  def show
    @ta_as_user = User.find_by(google_email: @teaching_assistant.email)
  end

  # GET /teaching_assistants/new
  def new
    @teaching_assistant = TeachingAssistant.new
  end

  # GET /teaching_assistants/1/edit
  def edit
  end

  # POST /teaching_assistants
  # POST /teaching_assistants.json
  def create
    @teaching_assistant = TeachingAssistant.new(teaching_assistant_params)

    respond_to do |format|
      if @teaching_assistant.save
        format.html { redirect_to @teaching_assistant, notice: 'Teaching assistant was successfully created.' }
        format.json { render :show, status: :created, location: @teaching_assistant }
      else
        format.html { render :new }
        format.json { render json: @teaching_assistant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teaching_assistants/1
  # PATCH/PUT /teaching_assistants/1.json
  def update
    respond_to do |format|
      if @teaching_assistant.update(teaching_assistant_params)
        format.html { redirect_to @teaching_assistant, notice: 'Teaching assistant was successfully updated.' }
        format.json { render :show, status: :ok, location: @teaching_assistant }
      else
        format.html { render :edit }
        format.json { render json: @teaching_assistant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teaching_assistants/1
  # DELETE /teaching_assistants/1.json
  def destroy
    @teaching_assistant.destroy
    respond_to do |format|
      format.html { redirect_to teaching_assistants_url, notice: 'Teaching assistant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teaching_assistant
      @teaching_assistant = TeachingAssistant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teaching_assistant_params
      params.require(:teaching_assistant).permit(:name, :email, :phone_number, course_ids: [], time_block_ids: [])
    end
end
