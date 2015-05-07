class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # if you want to restrict the access via IP uncomment the following line:
  #before_filter :restrict_access

  # Needed to restrict access to a set of IP's only. We don't want random users trying to access the admin interface
    def restrict_access
      if Rails.env == 'development' or Rails.env == 'test'
        whitelist = ['::1'].freeze
      else
        whitelist = ['IP'].freeze
      end

      unless whitelist.include? request.remote_ip
        remote = request.remote_ip
        render :text => 'Access denied for' + remote + '!'
      end
    end

  private

  def close_io_tasks
    tasks_hash = Hash.new
    tasks_hash = close_io.list_leads('task_updated:"today"')
    tasks_hash.data
  end

  def close_io
    closeio = Closeio::Client.new(Rails.application.secrets.close_io)
  end

  def nexmo_client
    nexmo = Nexmo::Client.new(key: Rails.application.secrets.nexmo_key, secret: Rails.application.secrets.nexmo_secret)
  end

end
