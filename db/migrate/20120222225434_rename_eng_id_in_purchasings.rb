class RenameEngIdInPurchasings < ActiveRecord::Migration
  change_table :purchasings do |t|
    t.rename :eng_id, :pur_eng_id
  end
end
