class RequestsController < ApplicationController
	def index
		@requests = Request.all
	end

	def show
		@request = Request.find(params[:id])
	end

	def new
		redirect_to root_url, notice: "Please, sign in!" unless current_user
		@request = Request.new
	end

	def create
		blocks = request_params[:preference_blocks]
		dates = request_params[:preference_dates]
		new_params = request_params.except(:preference_blocks, :preference_dates)
		@request = Request.new(new_params)
		priority = 0
		@request.preferences = blocks.zip(dates).map{|b, d|
			next unless b.to_i > 0
			next unless d["(3i)"] != ""
			priority += 1
			Preference.new(
				time_block_id: b.to_i,
				priority: priority,
				date: Date.civil(*d.to_h.sort.map(&:last).map(&:to_i)),
			)
		}.compact
		@request.user = current_user
		respond_to do |format|
	      if @request.save
	        format.html { redirect_to @request, notice: 'Request was successfully created.' }
	        format.json { render :show, status: :created, location: @request }
	      else
	        format.html { render :new }
	        format.json { render json: @request.errors, status: :unprocessable_entity }
	      end
	    end
  	end

	def destroy
		@request = Request.find(params[:id])
		@request.destroy
		redirect_to requests_path
	end

	private
		def request_params
			params.require(:request).permit(
				:participants, :contents, :user_id, :course_id,
				preference_blocks: [], preference_dates: ["(3i)", "(2i)", "(1i)"],
			)
		end
end
