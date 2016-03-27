class DashboardsController < ApplicationController
  layout 'dashboard'
  
  before_filter :set_main_items
  before_filter :set_dashboard, only: [:show, :widgets, :update]
  
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

    if dashboard.save
      render json: {messages: [], status: 'ok', dashboard_id: dashboard.id}
    else
      render json: {messages: dashboard.errors.messages, status: 'error'}
    end
  end

  def update
    @dashboard.dashboard_widgets.map(&:delete)
    widgets_params.each do |widget_params|
      @dashboard.dashboard_widgets << DashboardWidget.new(widget_params)
    end

    if @dashboard.save
      render json: {messages: [], status: 'ok', dashboard_id: @dashboard.id}
    else
      render json: {messages: @dashboard.errors.messages, status: 'error'}
    end
  end

  def widgets
    render json: @dashboard.to_json(include: {dashboard_widgets: {include: :widget}})
  end
  
  private
  def set_dashboard
    @dashboard = Dashboard.find(params[:id])
  end

  def dashboard_params
    params.require(:dashboard).permit(:name)
  end

  def widgets_params
    params.permit(widgets: [:name, :entity_id, :entity_type, :refresh_time, :limits, :widget_id, :top, :left, :width, :height, :x_axis, :y_axis, :y_axis_as, :x_axis_group]).require(:widgets)
  end

  def set_main_items
    @dashboards = Dashboard.all
    @widgets = Widget.all
  end
end
