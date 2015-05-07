class AddSidToReminder < ActiveRecord::Migration
  def change
    add_column :reminders, :sid, :string
  end
end
