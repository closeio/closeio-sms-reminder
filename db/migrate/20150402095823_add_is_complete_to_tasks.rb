class AddIsCompleteToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :is_complete, :boolean, :default => false
  end
end
