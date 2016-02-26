class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :name
      t.text :sql, :regular_expression
      t.references :source
      t.integer :observations_type, default: 0

      t.timestamps null: false
    end
  end
end
