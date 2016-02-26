class ContainersController < ApplicationController
  before_filter :set_main_items
  
  def execute
    Container.tree(tree_params)
    
    render json: tree_params
  end
  
  private
  def set_main_items
    @reports = Report.all
    @components = Component.all
    @containers = Container.all
  end

  def tree_params
    params.require(:tree)
  end
end
