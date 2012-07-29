class CreatePaymentLogs < ActiveRecord::Migration
  def change
    create_table :payment_logs do |t|
      t.date :pay_date
      t.integer :sourcing_id
      t.integer :purchasing_id
      t.decimal :amount, :precision => 10, :scale => 2, :default => 0.00
      t.string :short_note
      t.integer :input_by_id

      t.timestamps
    end
  end
end
