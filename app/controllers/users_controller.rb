class UsersController < ApplicationController
  layout 'user'

  def login
    if request.post?
      if !params[:name].empty? && !params[:password].empty?
        if user = User.authenticate(name_credentials, password_credentials)
          set_user(user)
          redirect_to dashboards_url
        end
      end
    else
      redirect_to dashboards_url if logged?
    end
  end

  def logout
    session[:current] = nil
    redirect_to users_login_url
  end

  def register
    if request.post?
      @user = User.new(user_params)

      if @user.save
        redirect_to users_login_url
      else
        render :register
      end
    else
      @user ||= User.new
    end
  end

  private
  def user_params
    #params.require(:user).permit(:name, :password, :password_confirmation)
    params.require(:user).permit(:name, :password)
  end

  def name_credentials
    params.require(:name)
  end

  def password_credentials
    params.require(:password)
  end

  def set_user(user)
    session[:current] = user
  end
end
