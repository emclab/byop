class CreatePurchasingLogs < ActiveRecord::Migration
  def change
    create_table :purchasing_logs do |t|
      t.integer :purchasing_id
      t.text :log
      t.integer :input_by_id

      t.timestamps
    end
  end
end
