class CreateQualityIssues < ActiveRecord::Migration
  def change
    create_table :quality_issues do |t|
      t.string :name
      t.integer :project_id
      t.integer :production_id
      t.integer :installation_id
      t.integer :sourcing_id
      t.integer :purchasing_id
      t.date :report_date
      t.integer :report_by_id
      t.text :issue_desp
      t.text :root_cause
      t.text :quick_fix
      t.text :solution
      t.text :preventative_action
      t.boolean :case_closed, :default => false
      t.integer :input_by_id

      t.timestamps
    end
  end
end
