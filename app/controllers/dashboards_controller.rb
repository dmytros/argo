class DashboardsController < ApplicationController
  layout 'dashboard'
  
  before_filter :set_main_items
#  before_filter :set_cache_headers, only: [:new]
  
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
    widgets_params.each do |widget_params|
      dashboard.dashboard_widgets << DashboardWidget.new(widget_params)
    end

    dashboard.save

render nothing: true

#    dashboard = Dashboard.new(dashboard_params)
#    dashboard.save
#    render json: {messages: dashboard.errors.messages}
  end

  def show
    @dashboard = Dashboard.find(params[:id])

#    dashboard = Dashboard.find(params[:id])

#    render json: dashboard.to_json(include: {dashboard_widgets: {include: :widget}})
  end

  def widgets
    dashboard = Dashboard.find(params[:id])
    render json: dashboard.to_json(include: {dashboard_widgets: {include: :widget}})
  end
  
  private
  def dashboard_params
    params.require(:dashboard).permit(:name)
  end

  def widgets_params
    params.permit(widgets: [:entity_id, :entity_type, :refresh_time, :limits, :widget_id, :top, :left, :width, :height, :x_axis, :y_axis, :y_axis_as, :x_axis_group]).require(:widgets)
  end

  def set_main_items
    @dashboards = Dashboard.all
    @widgets = Widget.all
  end

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
