class Admin::SchedulersController < ApplicationController
  layout 'admin'
  before_filter :set_scheduler, except: [:list, :index, :new, :create]
  before_filter :get_reports, only: [:new, :create, :edit, :update]
  include ApplicationHelper

  def update
    if @scheduler.update_attributes(scheduler_params)
      flash[:notice] = 'Scheduler has been updated'
      redirect_to admin_schedulers_url
    else
      render :edit
    end
  end

  def new
    @scheduler = Scheduler.new
  end
  
  def create
    @scheduler = Scheduler.new(scheduler_params)
    if @scheduler.save
      flash[:notice] = 'Scheduler has been created'
      redirect_to admin_schedulers_url
    else
      render :new
    end
  end

  def destroy
    if @scheduler.destroy
      flash[:notice] = 'Scheduler has been deleted'
    else
      flash[:error] = 'Scheduler has not been deleted'
    end
    redirect_to admin_schedulers_url
  end
  
  def list
    data = Scheduler.all.map{|scheduler| 
      actions = []
      actions << view_context.link_to('Edit', url_for([:edit, :admin, scheduler]), class: "button button-pill button-flat")
      actions << view_context.link_to('Delete', url_for([:admin, scheduler]), method: :delete, class: "button button-pill button-flat")

      [
        (scheduler.report.name rescue ''),
        (timestamp_format_tag(scheduler.start_at) rescue ''),
        (timestamp_format_tag(scheduler.end_at) rescue ''),
        scheduler.period,
        (timestamp_format_tag(scheduler.last_run_at) rescue ''),
        actions.join(' ')
      ]
    }
    
    render json: {'data' => data}.to_json
  end
  
  private
  def set_scheduler
    @scheduler = Scheduler.find(params[:id])
  end
  
  def get_reports
    @reports = Report.all
    #@reports = Report.not_in_scheduler
  end
  
  def scheduler_params
    params.require(:scheduler).permit(:report_id, :start_at, :end_at, :repeat_every, :repeat_type)
  end
end
