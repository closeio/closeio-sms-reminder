class ReminderMailer < ApplicationMailer

  default :from => "support@example.com"

  def send_calendar_invitation(email, meeting, date)
    if File.exist?("#{Rails.root}/tmp/" + meeting.to_s + "meeting.ics")
      @date = date.to_s
      @date_formatted = Time.parse(@date).to_time
      @date_formatted = @date_formatted.strftime("%d.%m.%Y %H:%M")
      #attachments["meeting.ics"] = File.read("#{Rails.root}/tmp/" + meeting.to_s + "meeting.ics")
      attachments["invite.ics"] = File.read("#{Rails.root}/tmp/" + meeting.to_s + "meeting.ics")
      mail(:to => email, :subject => "Telefontermin COMPANY am #{@date_formatted} Uhr")
      File.delete("#{Rails.root}/tmp/" + meeting.to_s + "meeting.ics")
    end
  end

end
