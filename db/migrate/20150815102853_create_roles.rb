class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, :sys_name

      t.timestamps null: false
    end
  end
end
