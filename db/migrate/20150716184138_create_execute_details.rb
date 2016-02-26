class CreateExecuteDetails < ActiveRecord::Migration
  def change
    create_table :execute_details do |t|
      t.string :name
      t.references :executable, polymorphic: true, index: true
      t.integer :rows_count
      t.boolean :is_success
      t.float :spent_time
      t.text :message

      t.timestamps null: false
    end
  end
end
