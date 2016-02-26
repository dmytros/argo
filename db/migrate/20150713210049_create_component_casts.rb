class CreateComponentCasts < ActiveRecord::Migration
  def change
    create_table :component_casts do |t|
      t.references :component
      t.references :cast
      t.string :position, default: 'in', null: false

      t.timestamps null: false
    end
  end
end
