class TaskController < ApplicationController

  def import
    @imported_today = Task.where(:created_at => (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day),
                                 :updated_at => (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day))
  end

  def import_with_queue
    list_tasks_width_call
  end

  def list_tasks_width_call
    if close_io_tasks.presence
      close_io_tasks.each do |task|
        task.tasks.each do |t|
        the_task = Task.where(:task_id => t.id).first
        if contact_from_lead(t.lead_id).present?
          note = "AirBot: Termineinladung verschickt + SMS Erinnerung 10 Minuten vor dem Telefontermin am:"
        else
          note = "AirBot: Termineinladung verschickt 10 Minuten vor dem Telefontermin am:"
        end
          if t.text.include? Rails.application.secrets.call_keyword and t.due_date.present?
            if the_task.nil?
              the_task = Task.new
              the_task.task_id       = t.id
              the_task.lead_id       = t.lead_id
              the_task.phone         = contact_from_lead(t.lead_id)
              the_task.due_date      = t.due_date.in_time_zone
              the_task.ref_name      = name_from_lead
              the_task.last_update   = DateTime.parse(t.date_updated).to_i
              the_task.is_complete   = t.is_complete
              the_task.email         = email_from_lead
              the_task.processed     = "false"
              the_task.save!
              if the_task.email.presence
                the_task.to_cal
              end
              due_to = the_task.due_date.to_s
              due_to = Time.parse(due_to).to_time
              due_to = due_to.strftime("%d.%m.%Y %H:%M")
              close_io.create_note(:note    => "#{note} #{due_to}",
                                   :lead_id => the_task.lead_id)

            elsif the_task.present? and the_task.due_date.present?
              if the_task.last_update < DateTime.parse(t.date_updated).to_i
                  the_task.phone       = contact_from_lead(t.lead_id)
                  the_task.due_date    = t.due_date.in_time_zone
                  the_task.ref_name    = name_from_lead
                  the_task.is_complete = t.is_complete
                  the_task.last_update = DateTime.parse(t.date_updated).to_i
                  the_task.email       = email_from_lead
                  the_task.save!
              end
            elsif the_task and the_task.due_date.blank?
              if the_task.last_update.to_i < DateTime.parse(t.date_updated).to_i
                the_task.is_complete = true
                the_task.save!
              end
            end
          end
        end
      end
    end
  end

  def contact_from_lead(lead_id)
    @lead = close_io.find_lead(lead_id)
    mobile_phone = ''
    @lead.contacts.each do |contact|
      contact.phones.each do |phone|
        if phone.type == "mobile"
          mobile_phone = phone.phone_formatted
        end
      end
    end
    mobile_phone
  end

  def name_from_lead
    name = ''
    if @lead
      @lead.contacts.each do |contact|
        name = contact.name
      end
      name
    end
  end

  def email_from_lead
    email_user = ''
    if @lead
      @lead.contacts.each do |contact|
        contact.emails.each do |user|
          email_user = user.email
        end
      end
    end
    email_user
  end
end

