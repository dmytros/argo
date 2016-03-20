class ReportsController < ApplicationController
  layout 'report'
  before_action :set_report, except: [:list, :index]
  include ApplicationHelper

  def list
    data = Report.all.map{|report|
      actions = []
      if report.observations.count > 0
        actions << view_context.link_to('Observations', url_for([:observations, report]), class: "button button-pill button-flat")
      end

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

  def observations
    @columns = @report.observations.first.keys
  end

  def observations_collection
    render json: {'data' => @report.observations.map(&:values)}.to_json
  end

  def execute
    render json: @report.execute
  end
  
  def columns
    render json: @report.observations(limit: 1).columns
  end
  
  def last_value
    render text: @report.observations(limit: 1).last.inspect
  end
  
  def display
    begin
      data = @report.observations(limit: params[:limit], group: {
        y_as: params[:columns][:y_axis_as], 
        format: params[:columns][:x_axis_group],
        x_axis: params[:columns][:x_axis],
        y_axis: params[:columns][:y_axis]
      })
      generated_id = (0...50).map { ('a'..'z').to_a[rand(26)] }.join

      if params[:widget_id] == Widget::Type::TABLE
        render partial: 'dashboards/widgets/table', locals: {
          table_id: generated_id,
          columns: data.columns.map{|column| {"title" => column}}.to_json,
          data: data.rows.to_json
        }
      else
        columns_list = data.columns
        columns_positions = []
        columns_positions << columns_list.index(params[:columns][:x_axis])
        columns_positions << columns_list.index(params[:columns][:y_axis])

        if params[:widget_id] == Widget::Type::LINE
          render partial: 'dashboards/widgets/line', locals: {
            line_id: generated_id,
            columns: params[:columns],
            data: data.rows.map {|row|
              [Date.parse(row[columns_positions[0]]), row[columns_positions[1]]]
            }
          }
        elsif params[:widget_id] == Widget::Type::COLUMN
          render partial: 'dashboards/widgets/column', locals: {
            column_id: generated_id,
            columns: params[:columns],
            data: data.rows.map {|row|
              [row[columns_positions[0]], row[columns_positions[1]]]
            }
          }
        elsif params[:widget_id] == Widget::Type::PIE
          render partial: 'dashboards/widgets/pie', locals: {
            column_id: generated_id,
            columns: params[:columns],
            data: data.rows.map {|row|
              [row[columns_positions[0]], row[columns_positions[1]]]
            }
          }
        end
      end
    rescue Exception => e
      render partial: 'dashboards/widgets/error', locals: {msg: e.message}
    end
  end

  private
  def set_report
    @report = Report.find(params[:id])
  end
end
