require 'rails_helper'

RSpec.describe Reminder, type: :model do
  describe ".template_message" do
    it "returns a string templated when we have name and time" do
      template = FactoryGirl.create(:template)
      template_name = template.name
      message = template.template
      name = "Lorenzo"
      time = "25"
      templated_message = Reminder.templated_message(name, time)
      templated_message.should eq("Hello dear #{name}, this is a friendly reminder from Airfy to inform you about our call in #{time} minutes")
    end
    it "returns a general template when we have no name and no time" do
      template = FactoryGirl.create(:template)
      template_name = template.name
      message = template.template
      name = ""
      time = ""
      templated_message = Reminder.templated_message(name, time)
      templated_message.should eq("Hallo Herr/Frau, wir möchten Sie daran erinnern, dass Ihr Gespräch in wenigen Minuten beginnt. Ihr Airfy-Team.")
    end
    it "returns default sms when there is no name or time set" do
      template = ""
      name = ""
      time = ""
      templated_message = Reminder.templated_message(name, time)
      templated_message.should eq("Hallo Herr/Frau, wir möchten Sie daran erinnern, dass Ihr Gespräch in wenigen Minuten beginnt. Ihr Airfy-Team.")
    end
  end
end
