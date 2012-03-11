class RemoveDateSinceFromSuppliers < ActiveRecord::Migration
  def up
    remove_column :suppliers, :date_since
  end
 
  def down
    add_column :suppliers, :date_since, :date
  end
end
