class CreateDashboardWidgets < ActiveRecord::Migration
  def change
    create_table :dashboard_widgets do |t|
      t.references :dashboard, :widget
      t.references :entity, polymorphic: true, index: true
      t.integer :refresh_time, :top, :left, :width, :height
      t.integer :limits
      t.string :x_axis, :y_axis

      t.timestamps null: false
    end
  end
end
