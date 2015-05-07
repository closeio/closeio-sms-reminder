require 'rails_helper'

describe Task do
  let!(:tasks) { Array.new(3) { Task.create!(task_id: '32t3grw' + Random.rand(2).to_s,
                                            lead_id: 'ceklg' + Random.rand(2).to_s,
                                            phone: '+4985868589' + Random.rand(2).to_s,
                                            due_date: Date.today,
                                            is_complete: [true, false].sample.to_s,
                                            ref_name: 'Mr. Bob',
                                            email: "info@lorenzosinisi.com",
                                            last_update: DateTime.now.to_i) } }


  subject { Task.all }

  it "is valid with a task id, lead id contact number, name, flag and due date" do
    task = Task.create(
      task_id: '32t3grwvr3t453',
      lead_id: 'ceklgcliugb0',
      phone: '+4985868589',
      due_date: Date.today,
      is_complete: false,
      ref_name: 'Mr. Bob',
      last_update: DateTime.now.to_i)
    expect(task).to be_valid
  end
  it "is invalid without a task id" do
    task = Task.create(task_id: nil)
    task.valid?
    task.errors[:task_id].should include("can't be blank")
  end
  it "deletes delete taks on closeio" do
    expect(subject).to match_array(tasks)
    tasks_hash = Hash.new
    close_io = Closeio::Client.new(Rails.application.secrets.close_io)
    tasks_hash = close_io.list_leads('task_updated:"today" task_created:"today"')
    tasks_hash.data
    Task.delete_deleted_tasks.empty? == true
    tasks.empty? == true
  end
  it "don't break even the Array of tasks is empty" do
    tasks = Task.destroy_all
    tasks_hash = Hash.new
    close_io = Closeio::Client.new(Rails.application.secrets.close_io)
    tasks_hash = close_io.list_leads('task_updated:"today" task_created:"today"')
    tasks_hash.data
    Task.delete_deleted_tasks.empty? == true
    tasks.empty? == true

  end
  it "is invalid without a lead id" do
    task = Task.create(lead_id: nil)
    task.valid?
    task.errors[:lead_id].should include("can't be blank")
  end
  it "is invalid without a name" do
    task = Task.create(ref_name: nil)
    task.valid?
    task.errors[:ref_name].should include("can't be blank")
  end
  it "is invalid without a flag" do
    task = Task.create(is_complete: nil)
    task.valid?
    task.errors[:is_complete].should include("requires a true or false value")
  end
  it "is invalid without a due date" do
    task = Task.create(due_date: nil)
    task.valid?
    task.errors[:due_date].should include("can't be blank")
  end
  it "returns a due date aligned with the current timezone" do
    task = Task.create(
      task_id: '32t3grwvr3t453',
      lead_id: 'ceklgcliugb0',
      phone: '+4985868589',
      due_date: Date.today.in_time_zone,
      is_complete: false,
      ref_name: 'Mr. Bob',
      last_update: DateTime.now.to_i)
    task.due_date.should eq(Date.today.in_time_zone)
  end

  describe ".to_cal" do
    it "is able to instantiate the calendar gem" do
      cal = Icalendar::Calendar.new
      cal.should be_an_instance_of(Icalendar::Calendar)
    end
    it "creates and event with alarm" do
    cal = Icalendar::Calendar.new
    time = DateTime.now
    cal.event do |e|
      e.dtstart     = Icalendar::Values::DateTime.new time
      e.dtend       = Icalendar::Values::DateTime.new time + 30.minutes
      e.summary     = "Ihr Termin mit Airfy"
      e.description = "Ihr Termin mit Airfy"
      e.ip_class    = "PRIVATE"
      e.alarm do |a|
        a.action        = "AUDIO"
        a.trigger       = "-PT10M"
        a.append_attach "Basso"
      end
      end
      cal.publish
      cal.publish.should eq("PUBLISH")
      cal.events.first.ip_class.should eq("PRIVATE")
      cal.events.first.dtstart.should eq(time)
      cal.events.first.alarm.should be_present
    end
  end

end
