class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :name
      t.text :expression

      t.timestamps null: false
    end
  end
end
