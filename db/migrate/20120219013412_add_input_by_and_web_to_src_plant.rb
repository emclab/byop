class AddInputByAndWebToSrcPlant < ActiveRecord::Migration
  def change
    add_column :src_plants, :input_by_id, :integer
    add_column :src_plants, :web, :string
  end
end
