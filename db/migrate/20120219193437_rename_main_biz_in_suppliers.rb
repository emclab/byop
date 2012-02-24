class RenameMainBizInSuppliers < ActiveRecord::Migration
  change_table :suppliers do |t|
    t.rename :main_biz, :main_product
  end
end
