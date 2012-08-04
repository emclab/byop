class AddStampedToSourcings < ActiveRecord::Migration
  def change
    add_column :sourcings, :stamped, :boolean, :default => false
  end
end
