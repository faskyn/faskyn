class TaskMailer < ActionMailer::Base

  def task_created(current_user, task)
    @current_user = current_user
    @task= task

    mail(from: 'faskyn@gmail.com',
         to: "#{task.executor.email}",
         subject: "[Faskyn] New task/favor from #{task.executor.profile.first_name} #{task.executor.profile.last_name}"
         )
  end
end