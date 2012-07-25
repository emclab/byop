class AddTotalToPurchasings < ActiveRecord::Migration
  def change
    add_column :purchasings, :total, :decimal, :precision => 10, :scale => 2
  end
end
