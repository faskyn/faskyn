class TaskcreatorWorker
  include Sidekiq::Worker

  #def perform(h, count)
    #h = JSON.load(h)
    #TaskMailer.task_created(h['task_assigner_first_name'], h['task_assigner_last_name'], h['task_executor_first_name'], h['task_executor_email'], h['task_executor_id'], h['task_id']).deliver_later
  #end

  def perform(task_id, user_id, count) # Removed count since you weren't using it. Add it back if needed
    TaskMailer.task_created(
      Task.find(task_id),
      User.find(user_id)
    ).deliver_now # deliver_now since we're already in a sidekiq worker
  end
end