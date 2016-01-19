class TaskMailer < ActionMailer::Base

  def task_created(task, user)
    @task = task
    @current_user = user

    mail(from: 'faskyn@gmail.com',
         to: "#{task.executor.email}",
         subject: "[Faskyn] New task/favor from #{task.assigner.profile.first_name} #{task.assigner.profile.last_name}"
         )
  end
end