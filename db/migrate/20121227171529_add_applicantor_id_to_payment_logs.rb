class AddApplicantorIdToPaymentLogs < ActiveRecord::Migration
  def change
    add_column :payment_logs, :applicantor_id, :integer
  end
end
