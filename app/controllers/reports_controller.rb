class ReportsController < ApplicationController
  def execute
    report = Report.find(params[:id])
    render json: report.execute
  end
  
  def columns
    report = Report.find(params[:id])
    render json: report.observations(limit: 1).columns
  end
  
  def last_value
    report = Report.find(params[:id])
    render text: report.observations(limit: 1).last.inspect
  end
  
  def display
    begin
      report = Report.find(params[:id])
      data = report.observations(limit: params[:limit])
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
end
