class AddUpdatedAtToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :last_update, :integer
  end
end
