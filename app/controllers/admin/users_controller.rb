class Admin::UsersController < ApplicationController
  layout 'admin'
  before_action :set_user, except: [:list, :index]

  def list
    data = User.all.map{|user| 
      actions = []
      if !user.super?
        actions << view_context.link_to('Edit', url_for([:edit, :admin, user]), class: "button button-pill button-flat")
        actions << view_context.link_to('Delete', url_for([:admin, user]), method: :delete, class: "button button-pill button-flat")

        actions << if !user.active?
          view_context.link_to('Activate', url_for([:activate, :admin, user]), class: "button button-pill button-flat")
        else
          view_context.link_to('Deactivate', url_for([:deactivate, :admin, user]), class: "button button-pill button-flat")
        end
      end

      [
        user.name,
        (user.role.name rescue ''),
        actions.join(' ')
      ]
    }
    
    render json: {'data' => data}.to_json
  end

  def update
    params[:user].delete(:password) if user_params[:password].empty?

    if @user.update_attributes(user_params)
      flash[:notice] = 'User has been updated'
      redirect_to admin_users_url
    else
      render :edit
    end
  end

  def activate
    @user.activate
    redirect_to admin_users_url
  end

  def deactivate
    @user.deactivate
    redirect_to admin_users_url
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :password, :role_id)
  end
end
