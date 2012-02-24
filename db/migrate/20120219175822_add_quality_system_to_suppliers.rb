class AddQualitySystemToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :quality_system, :string
  end
end
