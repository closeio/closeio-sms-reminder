require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

every(10.seconds, 'clean up deleted tasks') { Task.delete_deleted_tasks }
every(15.seconds, 'close io import') { TaskController.new.import_with_queue }
every(15.seconds, 'sms sending') { RemindersController.new.check_and_queue }
