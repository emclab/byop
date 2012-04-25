class ChangeDataTypesInInstallationPurchases < ActiveRecord::Migration
  
  def self.up
    change_table :installation_purchases do |t|
      t.change :qty, :integer
      t.change :qty_purchased, :integer
      t.change :qty_in_stock, :integer
    end
  end
  
  def self down
    change_table :installation_purchases do |t|
      t.change :qty, :decimal, :precision => 6, :scale => 2
      t.change :qty_purchased, :decimal, :precision => 6, :scale => 2
      t.change :qty_in_stock, :decimal, :precision => 6, :scale => 2
    end
  end
end
