class Task < ActiveRecord::Base
  validates :task_id, :lead_id, :due_date, :ref_name, :last_update, :presence => true
  validates :is_complete, :inclusion => {:in => [true, false], :message => 'requires a true or false value' }

  def self.delete_deleted_tasks
    close_io = Closeio::Client.new(Rails.application.secrets.close_io)
    tasks = Task.where(:created_at => (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day),
                       :updated_at => (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day))
    if !tasks.nil?
      tasks.each do |task|
        lead = close_io.find_task(task.task_id)
        if lead.error and "Empty query".in? lead.error
          task.destroy
        end
      end
    end
  end

  def to_cal
    cal = Icalendar::Calendar.new
    cal.event do |e|
      e.dtstart     = Icalendar::Values::DateTime.new self.due_date
      e.dtend       = Icalendar::Values::DateTime.new self.due_date + 30.minutes
      e.summary     = "Ihr Telefontermin mit Airfy"
      e.description = "Wir melden uns telefonisch bei Ihnen. Bei Rückfragen erreichen Sie uns unter 0800-666-1337 oder support@airfy.com"
      e.ip_class    = "PRIVATE"
        e.alarm do |a|
          a.action        = "AUDIO"
          a.trigger       = "-PT10M"
          a.append_attach "Basso"
        end
      end
    cal.publish
    file = File.new("./tmp/" + self.id.to_s + "meeting.ics", "w+")
    file.write(cal.to_ical)
    file.close
    ReminderMailer.send_calendar_invitation(self.email, self.id, self.due_date).deliver_now
  end
end
