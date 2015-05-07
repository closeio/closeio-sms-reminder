class RemindersController < ApplicationController
  before_action :set_reminder, only: [:show, :edit, :update, :destroy]

  def index
    @reminders = Reminder.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end

  def check_and_queue
    @tasks = Task.all
    if @tasks.presence
      @tasks.each do |task|
        if !task.processed and about_one_hour_left(task.due_date) and !task.is_complete
          appointment_in = (task.due_date.to_i - Time.now.to_i) / 60
          task.processed = true
          task.save!
          reminder = Reminder.create!(:name        => task.ref_name,
                                      :template_id => 1,
                                      :message     => Reminder.templated_message(task.ref_name, appointment_in),
                                      :phonenumber => clean_phone_number(task.phone),
                                      :appointment => task.due_date.in_time_zone)
          if reminder.save and reminder.phonenumber.present?
            number_formatted = clean_phone_number(task.phone)
            sms = nexmo_client.send_message(from: 'Airfy', to: "#{number_formatted}", text: reminder.message)
            if sms['status'] == "0"
              reminder.update_attributes :received => true,
                                         :sent     => true
              close_io.create_note(:note    => "AirBot: SMS Erinnerung verschick",
                                   :lead_id => task.lead_id)
            end
          end
        end
      end
    end
  end

  def about_one_hour_left(due_date)
    if (due_date.in_time_zone > Time.zone.now) and (due_date.in_time_zone < 1.hour.since(Time.zone.now))
      true
    else
      false
    end
  end

  def show
  end


  def new
    @reminder = Reminder.new
    @reminder.appointment ||= Time.zone.today
  end

  def create
    @reminder = Reminder.new(reminder_params)
    respond_to do |format|
      if @reminder.save
        format.html { redirect_to @reminder, notice: "SMS sent"}
        format.json { render :show, status: :created, location: @reminder }
      else
        format.html { render :new }
        format.json { render json: @reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  def clean_phone_number(number)
    number.gsub("(", "").gsub(")", "").gsub("-", "").gsub(".", "").gsub(" ", "")
  end

  private

    def set_reminder
      @reminder = Reminder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reminder_params
      params.require(:reminder).permit(:name, :template_id, :message, :phonenumber, :appointment)
    end
end
