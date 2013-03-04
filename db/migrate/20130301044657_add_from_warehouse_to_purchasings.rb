class AddFromWarehouseToPurchasings < ActiveRecord::Migration
  def change
    add_column :purchasings, :from_warehouse, :boolean, :default => false
  end
end
