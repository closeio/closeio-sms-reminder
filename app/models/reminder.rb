class Reminder < ActiveRecord::Base
  belongs_to :template
  validates :message, presence: true, :length => { :maximum => 200 }

  def self.templated_message(name, at_time)
    template_name = Rails.application.secrets.template
    template = Template.where(:name => template_name).first
    if !template.blank? and !name.blank? and !at_time.blank?
      if "{time}".in? template.template
        template.template.gsub!("{time}", at_time.to_s)
        template.template
      else
        template.template
      end
    else
      "Hallo Herr/Frau, wir möchten Sie daran erinnern, dass Ihr Gespräch in wenigen Minuten beginnt. Ihr Airfy-Team."
    end
  end
end
