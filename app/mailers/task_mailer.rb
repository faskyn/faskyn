class TaskMailer < ActionMailer::Base
  default from: 'faskyn@gmail.com'

  def task_created(task, executor, assigner)
    @task = task
    @executor = executor
    @assigner = assigner

    mail(
        to: "#{executor.email}",
        subject: "[Faskyn] New message from #{assigner.profile.full_name}"
        )
  end
end