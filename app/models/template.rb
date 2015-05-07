class Template < ActiveRecord::Base
  has_many :reminders
  validates :template, presence: true, :length => { :minimum => 1}
  validates :name, presence: true, :length => { :minimum => 1}
end
