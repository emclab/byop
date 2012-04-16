class ChangeBudgetInProjects < ActiveRecord::Migration
  def self.up
    change_table :projects do |t|
      t.change :budget, :decimal, :precision => 10, :scale => 2
    end
  end
  
  def self down
    change_table :projects do |t|
      t.change :budget, :string
    end
  end
end
