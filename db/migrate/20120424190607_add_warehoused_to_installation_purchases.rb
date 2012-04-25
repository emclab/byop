class AddWarehousedToInstallationPurchases < ActiveRecord::Migration
  def change
    add_column :installation_purchases, :warehoused, :boolean, :default => false
  end
end
