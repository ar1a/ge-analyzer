class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_filter :check_rack_mini_profiler
  def check_rack_mini_profiler
    if current_user.username == 'ar1a' && params[:rmp]
      Rack::MiniProfiler.authorize_request
    end
  end

  protected

  def configure_permitted_parameters
    added_attrs = %i[username email password_confirmation password remember_me sorting_method]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
