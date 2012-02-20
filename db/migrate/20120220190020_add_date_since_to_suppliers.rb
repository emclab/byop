class AddDateSinceToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :date_since, :date
  end
end
