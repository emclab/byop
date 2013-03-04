class AddCheckedOutFromWarehouseToPurchasings < ActiveRecord::Migration
  def change
    add_column :purchasings, :checked_out_from_warehouse, :boolean, :default => false
  end
end
