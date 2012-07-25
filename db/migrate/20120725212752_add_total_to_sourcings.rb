class AddTotalToSourcings < ActiveRecord::Migration
  def change
    add_column :sourcings, :total, :decimal, :precision => 10, :scale => 2
  end
end
