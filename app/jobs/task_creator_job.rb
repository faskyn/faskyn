class TaskCreatorJob < ActiveJob::Base
  queue_as :default

  def perform(task_id, user_id)
    TaskMailer.task_created(Task.find(task_id), User.find(user_id)).deliver_now
  end
end
