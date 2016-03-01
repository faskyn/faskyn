class TaskCreatorJob < ActiveJob::Base
  queue_as :default

  def perform(task, executor, assigner)
    TaskMailer.task_created(task, executor, assigner).deliver
  end
end
