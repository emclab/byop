class AddEngidToSourcings < ActiveRecord::Migration
  def change
    add_column :sourcings, :eng_id, :integer
  end
end
