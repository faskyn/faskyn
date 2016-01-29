class TaskCreatorJob < ActiveJob::Base
  queue_as :default

  def perform(task_id, user_id)
    task = Task.find(task_id)
    user = User.find(user_id)
    TaskMailer.task_created(task, user).deliver
  end
end
