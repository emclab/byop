class AddActualReceivingDateToPurchasing < ActiveRecord::Migration
  def change
    add_column :purchasings, :actual_receiving_date, :date
  end
end
