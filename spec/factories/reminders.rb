FactoryGirl.define do
  factory :reminder, :class => 'Reminder' do |re|
    re.name { Faker::Name.name }
    re.message { Faker::Lorem.sentence }
    re.phonenumber { Faker::PhoneNumber.cell_phone }
    re.appointment { Faker::Date.between(2.days.ago, Date.today) }
    re.sent false
  end
end
