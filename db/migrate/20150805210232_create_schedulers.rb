class CreateSchedulers < ActiveRecord::Migration
  def change
    create_table :schedulers do |t|
      t.references :report
      t.timestamp :start_at, :end_at, :last_run_at
      t.integer :repeat_every, :repeat_type

      t.timestamps null: false
    end
  end
end
