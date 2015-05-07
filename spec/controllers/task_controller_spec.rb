require 'spec_helper'

describe TaskController, type: :controller do

  describe "GET 'import'" do
    it "returns http success" do
      get 'import'
      response.should be_success
    end
  end
  describe ".import" do
    it "returns a valid hash with needed" do
      task = Task.create(:task_id => "dakjchbailubj",
                         :lead_id => "cseiugeiuvb",
                         :due_date => Date.today,
                         :ref_name => "lorenzo sinisi" ,
                         :last_update => DateTime.now.to_i,
                         :is_complete => true)
      task.should be_valid
      task.task_id.should eq("dakjchbailubj")
    end
  end
  describe "create reminder if task is not processed" do
      it "creates a new task or update one if exist" do
        new_task = Task.new
        new_task.task_id = 1
        new_task.lead_id = "ceklgcliugb0"
        new_task.phone = "+4985868589"
        new_task.due_date =  "2015-04-07 22:00:00.000000"
        new_task.ref_name = "lorenzo sinisi"
        new_task.last_update = DateTime.now.to_i
        new_task.is_complete = false
        new_task.processed = false
        new_task.save!
        new_task.task_id.should eq("1")
        before = "2015-04-07 22:59:00.000000"
        after = "2015-04-07 23:00:00.000000"
        date_changed = before.to_time.to_i < after.to_time.to_i
        expect(date_changed).to eq(true)
      end
  end
  describe ".lead_email_address" do
    it "creates a new task or update one if exist" do
      new_task = Task.new
      new_task.task_id = 1
      new_task.lead_id = "ceklgcliugb0"
      new_task.phone = "+4985868589"
      new_task.due_date =  "2015-04-07 22:00:00.000000"
      new_task.ref_name = "lorenzo sinisi"
      new_task.last_update = DateTime.now.to_i
      new_task.is_complete = false
      new_task.processed = false
      new_task.save!
      new_task.task_id.should eq("1")
      before = "2015-04-07 22:59:00.000000"
      after = "2015-04-07 23:00:00.000000"
      date_changed = before.to_time.to_i < after.to_time.to_i
      expect(date_changed).to eq(true)
    end
  end
  describe ".email_from_lead" do
    it "fetch the single lead and returns the email address" do
      close_io = Closeio::Client.new(Rails.application.secrets.close_io)
      lead_id = "lead_7XkwmAG43TTWxORdLJ1Tba8ykK6ieWGzvzimZz8MBi6" # a lead from closeio with an email address
      @lead = close_io.find_lead(lead_id)
      expect(TaskController.new.email_from_lead).to eq("")
    end
  end

  describe "close io gem is present or not" do
    it "is present" do
      closeio = Closeio::Client.new(Rails.application.secrets.close_io)
      closeio.should be_an_instance_of Closeio::Client
    end
  end

end
