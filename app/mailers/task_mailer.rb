class TaskMailer < ActionMailer::Base

  def task_created(task, executor, assigner)
    @task = task
    @executor = executor
    @assigner = assigner

    mail(from: 'faskyn@gmail.com',
         to: "#{executor.email}",
         subject: "[Faskyn] New task/favor from #{assigner.profile.full_name}"
         )
  end
end