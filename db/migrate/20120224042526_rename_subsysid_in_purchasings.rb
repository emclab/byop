class RenameSubsysidInPurchasings < ActiveRecord::Migration
  change_table :purchasings do |t|
    t.rename :subsys_id, :proj_module_id
  end
end
