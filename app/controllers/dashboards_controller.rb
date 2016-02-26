class DashboardsController < ApplicationController
  layout 'dashboard'
  
  before_filter :set_main_items
  
  def widget_settings
    render json: {
      reports: Report.all, 
      refresh_time: Widget::REFRESH_TIME,
      limits: Widget::LIMITS
    }
  end
  
  def widget_data
    report = Report.find(params[:id])
    render json: {data: report.observations}
  end
  
  def create
    dashboard = Dashboard.new(dashboard_params)
    dashboard.save
    render json: {messages: dashboard.errors.messages}
  end
  
  private
  def dashboard_params
    params.require(:dashboard).permit(:name)
  end

  def set_main_items
    @dashboards = Dashboard.all
    @widgets = Widget.all
  end
end
