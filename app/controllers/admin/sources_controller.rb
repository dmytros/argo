class Admin::SourcesController < ApplicationController
  layout 'admin'
  before_filter :set_source, except: [:list, :index, :new, :create]
  
  def update
    if @source.update_attributes(source_params)
      flash[:notice] = 'Source has been updated'
      redirect_to admin_sources_url
    else
      render :edit
    end
  end
  
  def new
    @source = Source.new
  end
  
  def create
    @source = Source.new(source_params)
    if @source.save
      flash[:notice] = 'Source has been created'
      redirect_to admin_sources_url
    else
      render :new
    end
  end
  
  def destroy
    if @source.destroy
      flash[:notice] = 'Source has been deleted'
    end
    redirect_to admin_sources_url
  end
  
  def list
    data = Source.select(
      [:id, :name, :username, :host, :port, :database, :adapter, :path, :destination]
    ).map{|source| 
      row = source.attributes.except("id").values

      actions = []
      actions << view_context.link_to('Edit', url_for([:edit, :admin, source]), class: "button button-pill button-flat")
      actions << view_context.link_to('Delete', url_for([:admin, source]), method: :delete, class: "button button-pill button-flat")

      if source.destination == Source::DESTINATIONS[0]
        actions << view_context.link_to('Ping', url_for([:ping, :admin, source]), class: "button button-pill button-flat")
      elsif source.destination == Source::DESTINATIONS[1]
        actions << view_context.link_to('Check', url_for([:check, :admin, source]), class: "button button-pill button-flat")
      end

      row << actions.join(' ')
    }
    
    render json: {'data' => data}.to_json
  end
  
  def ping
    pinged = @source.has_connection?
    
    if 'ok' === pinged['status']
      flash[:notice] = "'#{@source.name}' is pingable"
    else
      flash[:notice] = "'#{@source.name}' has error: " + pinged['message']
    end
    
    redirect_to admin_sources_url
  end
  
  def check
    if File.exists?(@source.path)
      flash[:notice] = "'#{@source.name}' exists (#{@source.path})"
    else
      flash[:notice] = "'#{@source.name}' does not exist (#{@source.path})"
    end
    
    redirect_to admin_sources_url
  end
  
  def tables
    @tree = @source.tree

    render partial: 'tables_tree'
  end
  
  private
  def set_source
    @source = Source.find(params[:id])
  end
  
  def source_params
    params
      .require(:source)
      .permit(:name, :username, :host, :port, :database, :password, :adapter, :destination, :path)
  end
end
