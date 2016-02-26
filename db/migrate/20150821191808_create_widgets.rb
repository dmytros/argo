class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string :name, :sys
      t.text :description

      t.timestamps null: false
    end
  end
end
