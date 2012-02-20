class CreateCommLogs < ActiveRecord::Migration
  def change
    create_table :comm_logs do |t|
      t.string :subject
      t.string :via
      t.string :contact_with
      t.string :purpose
      t.text :log
      t.integer :input_by_id
      t.integer :customer_id

      t.timestamps
    end
  end
end
