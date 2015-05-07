class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.string :name
      t.text :message
      t.string :phonenumber
      t.datetime :appointment

      t.timestamps null: false
    end
  end
end
