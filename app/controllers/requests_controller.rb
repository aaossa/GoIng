class RequestsController < ApplicationController
    load_and_authorize_resource
    skip_load_resource only: :create

    def index
        # This can be improved or removed
        course_param = params.fetch(:course, "")
        @requests = unless course_param.empty?
            @requests.where(course_id: course_param)
        else
            @requests
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
        custom_params = request_params
        preferences_dates = custom_params.fetch(:preferences_dates, [])
        preferences_time_blocks = custom_params.fetch(:preferences_time_blocks, [])
        new_params = custom_params.except(:participants, :preferences_dates, :preferences_time_blocks)
        @request = Request.new(new_params)
        @request.participants = custom_params[:participants].to_hash.values
        @request.preferences = preferences_dates.zip(preferences_time_blocks).map{|date, tb|
            next unless tb.to_i > 0
            next unless Date.valid_date? *Array.new(3).zip(date.split('/')).transpose.last.reverse.map(&:to_i)
            Preference.where(
                time_block_id: tb,
                date: date.to_date,
            ).first_or_create
        }.compact
        @request.user = current_user
        respond_to do |format|
          if @request.save
            format.js
            format.html { redirect_to @request, notice: 'Request was successfully created.', turbolinks: false }
            format.json { render :show, status: :created, location: @request }
          else
            format.js   { render action: :new }
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
                :contents, :user_id, :course_id, :format,
                preferences_time_blocks: [],
                preferences_dates: [],
                participants: ["0", "1", "2", "3"],
            )
        end
end
