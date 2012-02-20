class AddEmailandFaxToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :fax, :string
    add_column :suppliers, :email, :string
  end
end
