class AddSentToReminder < ActiveRecord::Migration
  def change
    add_column :reminders, :sent, :boolean, :default => false
  end
end
