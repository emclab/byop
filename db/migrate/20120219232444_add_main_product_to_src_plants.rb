class AddMainProductToSrcPlants < ActiveRecord::Migration
  def change
    add_column :src_plants, :main_product, :text
  end
end
