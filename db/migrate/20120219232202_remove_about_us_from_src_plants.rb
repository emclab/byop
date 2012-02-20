class RemoveAboutUsFromSrcPlants < ActiveRecord::Migration
  def up
    remove_column :src_plants, :about_us
  end

  def down
    add_column :src_plants, :about_us, :text
  end
end
