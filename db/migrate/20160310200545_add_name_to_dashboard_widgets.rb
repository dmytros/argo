class AddNameToDashboardWidgets < ActiveRecord::Migration
  def change
    add_column :dashboard_widgets, :name, :string
  end
end
