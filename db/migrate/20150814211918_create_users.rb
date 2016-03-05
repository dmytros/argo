class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :hashed_password, :salt
      t.references :role

      t.timestamps null: false
    end
  end
end
