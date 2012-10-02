class AddApprovedByCeoApproveCeoIdApproveDateCeoToPaymentLogs < ActiveRecord::Migration
  def change
    add_column :payment_logs, :approved_by_ceo, :boolean
    add_column :payment_logs, :approve_ceo_id, :integer
    add_column :payment_logs, :approve_date_ceo, :datetime
  end
end
