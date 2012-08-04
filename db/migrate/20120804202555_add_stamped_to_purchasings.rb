class AddStampedToPurchasings < ActiveRecord::Migration
  def change
    add_column :purchasings, :stamped, :boolean, :default => false
  end
end
