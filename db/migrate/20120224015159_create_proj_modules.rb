class CreateProjModules < ActiveRecord::Migration
  def change
    create_table :proj_modules do |t|
      t.integer :project_id
      t.string :name
      t.integer :input_by_id

      t.timestamps
    end
  end
end
