class RequestsController < ApplicationController
	def index
		@requests = Request.all
	end

	def show
		@request = Request.find(params[:id])
	end

	def new
		@request = Request.new
	end

	def create
		@request = Request.new(request_params)
		@request.user_id = current_user.id if current_user
		puts @request.errors.inspect
		if @request.save
			redirect_to @request
		else
			render 'new'
		end
	end

	def destroy
		@request = Request.find(params[:id])
		@request.destroy
		redirect_to requests_path
	end

	private
		def request_params
			params.require(:request).permit(:participants, :contents, :user_id)
		end
end
