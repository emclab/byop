class CreatePayStatusLogs < ActiveRecord::Migration
  def change
    create_table :pay_status_logs do |t|
      t.integer :payment_log_id
      t.string :log
      t.integer :input_by_id

      t.timestamps
    end
  end
end
