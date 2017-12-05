class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_params_search
  before_action :set_locale

  protected

  def default_url_options
    { locale: I18n.locale }
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :avatar) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password, :is_male, :date_of_birth, :avatar) }
  end

  def check_params_search
    redirect_to root_path(search: params[:search]) if params[:search]
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
