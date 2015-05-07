class AddReceivedToReminder < ActiveRecord::Migration
  def change
    add_column :reminders, :received, :boolean, :default => false
  end
end
