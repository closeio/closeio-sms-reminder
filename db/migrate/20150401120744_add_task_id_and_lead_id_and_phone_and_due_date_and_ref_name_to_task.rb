class AddTaskIdAndLeadIdAndPhoneAndDueDateAndRefNameToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :task_id, :string
    add_column :tasks, :lead_id, :string
    add_column :tasks, :phone, :string
    add_column :tasks, :due_date, :datetime
    add_column :tasks, :ref_name, :string
  end
end
