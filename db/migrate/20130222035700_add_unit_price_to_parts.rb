class AddUnitPriceToParts < ActiveRecord::Migration
  def change
    add_column :parts, :unit_price, :decimal, :precision => 10, :scale => 2
  end
end
