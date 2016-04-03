class Admin::ReportsController < ApplicationController
  layout 'admin'
  before_filter :set_report, except: [:list, :index, :new, :create, :preview, :replace_macros]
  before_filter :set_sources, only: [:new, :create, :edit, :update]
  include ApplicationHelper
  
  def new
    @report = Report.new
  end
  
  def create
    @report = Report.new(report_params)
    @report.predefined_columns = params[:columns].values if params.has_key?('columns')
    if @report.save
      flash[:notice] = 'Report has been created'
      redirect_to admin_reports_url
    else
      render :new
    end
  end
  
  def update
    #@report.predefined_columns = params[:columns].values
    if @report.update_attributes(report_params)
      flash[:notice] = 'Report has been updated'
      redirect_to admin_reports_url
    else
      render :edit
    end
  end
  
  def destroy
    if @report.destroy
      flash[:notice] = 'Report has been deleted'
    else
      flash[:error] = 'Report has not been deleted'
    end
    redirect_to admin_reports_url
  end
  
  def list
    data = Report.all.map{|report| 
      actions = []
      if report.observations.count > 0
        actions << view_context.link_to('Observations', url_for([:observations, :admin, report]), class: "button button-pill button-flat")
      end
      actions << view_context.link_to('Edit', url_for([:edit, :admin, report]), class: "button button-pill button-flat")
      actions << view_context.link_to('Delete', url_for([:admin, report]), method: :delete, class: "button button-pill button-flat")

      [
        report.name,
        (report.source.name rescue ''),
        (timestamp_format_tag(report.execute_details.last.created_at) rescue ''),
        (bool_tag(report.execute_details.last.is_success) rescue ''),
        ((spent_time_tag(report.execute_details.last.spent_time)) rescue ''),
        (report.execute_details.last.rows_count rescue ''),
        (report.execute_details.where(is_success: true).count rescue ''),
        (report.execute_details.where(is_success: false).count rescue ''),
        actions.join(' ')
      ]
    }
    
    render json: {'data' => data}.to_json
  end
  
  def details
    render json: {sql: @report.sql, regular_expression: @report.regular_expression, observations_type_name: @report.observations_type_name, source_destination: @report.source.destination}.to_json
  end
  
  def preview
    report = Report.new(report_params)
    
    render json: report.execute(false).to_json
  end
  
  def observations
    @columns = @report.observations.first.keys
  end
  
  def observations_collection
    render json: {'data' => @report.observations.map(&:values)}.to_json
  end
  
  def replace_macros
    render text: Report.convert_macros(report_params[:regular_expression])
  end
  
  private
  def set_report
    @report = Report.find(params[:id])
  end
  
  def set_sources
    @sources = Source.all
  end
  
  def report_params
    params.require(:report).permit(:name, :sql, :regular_expression, :source_id, :observations_type, :columns)
  end
end
