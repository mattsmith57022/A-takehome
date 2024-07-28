class ApplicationController < ActionController::Base
  rescue_from StandardError, with: :rescue_catch_all
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    render json: 'not_found', status: :not_found
  end

  def rescue_catch_all
    render json: 'internal_server_error', status: :internal_server_error
  end
end
