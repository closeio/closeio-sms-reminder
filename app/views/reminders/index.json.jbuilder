json.array!(@reminders) do |reminder|
  json.extract! reminder, :id, :name, :message, :phonenumber, :appointment
  json.url reminder_url(reminder, format: :json)
end
