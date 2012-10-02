class AddPaidPaidDateToPaymentLogs < ActiveRecord::Migration
  def change
    add_column :payment_logs, :paid, :boolean, :default => false
    add_column :payment_logs, :paid_by_id, :integer
    add_column :payment_logs, :paid_date, :date
  end
end
