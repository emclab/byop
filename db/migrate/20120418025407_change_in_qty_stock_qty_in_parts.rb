class ChangeInQtyStockQtyInParts < ActiveRecord::Migration
  def self.up
    change_table :parts do |t|
      t.change :in_qty, :integer
      t.change :stock_qty, :integer
    end
  end
  
  def self down
    change_table :parts do |t|
      t.change :in_qty, :decimal
      t.change :stock_qty, :decimal
    end
  end
end
