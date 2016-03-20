class AddColumnsToDashboardWidgets < ActiveRecord::Migration
  def change
    add_column :dashboard_widgets, :y_axis_as, :string
    add_column :dashboard_widgets, :x_axis_group, :string
  end
end
