class TaskCreatorJob < ActiveJob::Base
  queue_as :default

  def perform(task_id)
    task = Task.find(task_id)
    executor = task.executor
    assigner = task.assigner
    TaskMailer.task_created(task, executor, assigner).deliver
  end
end
