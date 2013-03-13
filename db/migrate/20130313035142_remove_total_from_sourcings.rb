class RemoveTotalFromSourcings < ActiveRecord::Migration
  def up
    remove_column :sourcings, :total
  end

  def down
    add_column :sourcings, :total, :decimal
  end
end
