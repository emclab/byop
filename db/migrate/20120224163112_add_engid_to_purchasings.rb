class AddEngidToPurchasings < ActiveRecord::Migration
  def change
    add_column :purchasings, :eng_id, :integer
  end
end
