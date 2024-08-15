class ApplicationController < ActionController::API
  def authenticate_api
    api_key = request.headers["x-api-key"]
    return render json: { message: "Please provide API key"}, status: 403 if api_key.blank?

    @current_user = UserBase.find_by(api_key: api_key)
    return render json: { message: "invalid API key"}, status: 403 unless @current_user
  end
end
