require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the TaskHelper. For example:
#
# describe TaskHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe TaskHelper do
  describe "is time to send" do
    it "says if there is less than on our left from a now to a datetime" do
      due_date = "2015-04-08 9:40:00.000000"
      if (due_date.in_time_zone > Time.zone.now) and (due_date.in_time_zone < 1.hour.since(Time.zone.now))
        time = true
      else
        time = false
      end
      expect(time).to eq(false)
    end
  end
end
