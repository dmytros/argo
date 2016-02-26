class Admin::UsersController < ApplicationController
  layout 'admin'

  def list
    data = User.all.map{|user| 
      actions = []
      actions << view_context.link_to('Edit', url_for([:edit, :admin, user]), class: "button button-pill button-flat")
      actions << view_context.link_to('Delete', url_for([:admin, user]), method: :delete, class: "button button-pill button-flat")

      [
        user.name,
        (user.role.name rescue ''),
        actions.join(' ')
      ]
    }
    
    render json: {'data' => data}.to_json
  end
end
