class TaskcreatorWorker
  include Sidekiq::Worker

  def perform(h, count)
    h = JSON.load(h)
    TaskMailer.task_created(h['task_assigner_first_name'], h['task_assigner_last_name'], h['task_executor_first_name'], h['task_executor_email'], h['task_executor_id'], h['task_id']).deliver_later
  end
end