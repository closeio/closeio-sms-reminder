FactoryGirl.define do
  factory :template do
    template "Hello dear {name}, this is a friendly reminder from Airfy to inform you about our call in {time} minutes"
    name Rails.application.secrets.template
  end

end
