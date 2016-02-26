class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :name, :username, :host, :port, :database, :password, :adapter, :encoding, :pool
      t.string :destination, default: Source::DESTINATIONS[0]
      t.string :path

      t.timestamps null: false
    end
  end
end
