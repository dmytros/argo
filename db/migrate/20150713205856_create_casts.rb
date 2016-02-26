class CreateCasts < ActiveRecord::Migration
  def change
    create_table :casts do |t|
      t.string :name, :sys, :img_class

      t.timestamps null: false
    end
  end
end
