class RemoveTotalFromPurchasings < ActiveRecord::Migration
  def up
    remove_column :purchasings, :total
  end

  def down
    add_column :purchasings, :total, :decimal
  end
end
