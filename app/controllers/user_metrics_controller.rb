class UserMetricsController < ApplicationController

  # GET /user_metrics/percent_voted_in_multiple_polls or /user_metrics/percent_voted_in_multiple_polls.json
  def percent_voted_in_multiple_polls
    start_date = params[:start_date]
    end_date = params[:end_date]

    if start_date && end_date
      start_time = Time.zone.parse(start_date).beginning_of_day
      end_time = Time.zone.parse(end_date).end_of_day
      percent_data = User.percent_voted_in_multiple_polls(start_time, end_time)
      render json: { data: percent_data }, status: :ok
    else
      render json: 'start_date and end_date params are required.', status: :bad_request
    end
  end
end
