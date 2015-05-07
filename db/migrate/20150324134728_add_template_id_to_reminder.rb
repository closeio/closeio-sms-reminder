class AddTemplateIdToReminder < ActiveRecord::Migration
  def change
    add_column :reminders, :template_id, :integer
  end
end
