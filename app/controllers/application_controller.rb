class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize, except: [:login, :logout, :register]

  def logged?
    !session[:current].nil?
  end

  def is_admin?
  end
  
  def is_user?
  end

  private
  def authorize
    redirect_to users_login_url unless session[:current]
  end
end
