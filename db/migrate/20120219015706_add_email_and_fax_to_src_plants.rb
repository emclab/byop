class AddEmailAndFaxToSrcPlants < ActiveRecord::Migration
  def change
    add_column :src_plants, :email, :string
    add_column :src_plants, :fax, :string
  end
end
