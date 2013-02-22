class RemoveTotalFromInstallationPurchases < ActiveRecord::Migration
  def up
    remove_column :installation_purchases, :total
  end

  def down
    add_column :installation_purchases, :total, :decimal
  end
end
