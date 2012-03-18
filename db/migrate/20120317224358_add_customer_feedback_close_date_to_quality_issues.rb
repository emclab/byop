class AddCustomerFeedbackCloseDateToQualityIssues < ActiveRecord::Migration
  def change
    add_column :quality_issues, :customer_feedback, :text
    add_column :quality_issues, :close_date, :date
  end
end
