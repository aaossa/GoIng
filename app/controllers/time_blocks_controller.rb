class TimeBlocksController < ApplicationController
  load_and_authorize_resource

  before_action :set_time_block, only: [:show, :edit, :update, :destroy]

  # GET /time_blocks
  # GET /time_blocks.json
  def index
    course_param = params.fetch(:time_block, {}).fetch(:course, "")
    unless course_param.empty?
      course = Course.find(course_param)
      @time_blocks = course.available_modules
    else
      @time_blocks = TimeBlock.all
    end
  end

  # GET /time_blocks/1
  # GET /time_blocks/1.json
  def show
  end

  # GET /time_blocks/new
  def new
    @time_block = TimeBlock.new
  end

  # GET /time_blocks/1/edit
  def edit
  end

  # POST /time_blocks
  # POST /time_blocks.json
  def create
    @time_block = TimeBlock.new(time_block_params)

    respond_to do |format|
      if @time_block.save
        format.html { redirect_to @time_block, notice: 'Time block was successfully created.' }
        format.json { render :show, status: :created, location: @time_block }
      else
        format.html { render :new }
        format.json { render json: @time_block.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_blocks/1
  # PATCH/PUT /time_blocks/1.json
  def update
    respond_to do |format|
      if @time_block.update(time_block_params)
        format.html { redirect_to @time_block, notice: 'Time block was successfully updated.' }
        format.json { render :show, status: :ok, location: @time_block }
      else
        format.html { render :edit }
        format.json { render json: @time_block.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_blocks/1
  # DELETE /time_blocks/1.json
  def destroy
    @time_block.destroy
    respond_to do |format|
      format.html { redirect_to time_blocks_url, notice: 'Time block was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_block
      @time_block = TimeBlock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_block_params
      params.require(:time_block).permit(:day, :start, :finish, teaching_assistant_ids: [])
    end
end
