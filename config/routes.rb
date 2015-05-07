Rails.application.routes.draw do

  get 'mail/send_calendar_invitation'

  get 'task/import'
  resources :templates
  resources :reminders
  root 'reminders#index'

end
