class RequestsController < ApplicationController
	def index
		course_param = params.fetch(:course, "")
		@requests = unless course_param.empty?
			Request.where(course_id: course_param)
	    else
	    	Request.all
	    end
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
		new_params = request_params.except(:preference_blocks, :preference_dates, :participants)
		@request = Request.new(new_params)
		@request.participants = request_params[:participants].to_hash
		@request.preferences = blocks.zip(dates).map{|b, d|
			next unless b.to_i > 0
			Preference.where(
				time_block_id: b.to_i,
				date: Time.at(d.to_i).to_s(:db).to_date,
			).first_or_create
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
			# Force current_user email as participant
			params[:request][:participants]["0"] = current_user.google_email
			params.require(:request).permit(
				:contents, :user_id, :course_id,
				preference_blocks: [], preference_dates: [],
				participants: ["0", "1", "2", "3"],
			)
		end
end
