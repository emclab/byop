class CreateInstallations < ActiveRecord::Migration
  def change
    create_table :installations do |t|
      t.string :install_name
      t.date :start_date
      t.date :finish_date
      t.integer :input_by_id
      t.boolean :completed, :default => false
      t.integer :eng_id

      t.timestamps
    end
  end
end
