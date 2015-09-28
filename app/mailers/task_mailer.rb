class TaskMailer < ActionMailer::Base

  def task_created(task_assigner_first_name, task_assigner_last_name, task_executor_first_name, task_executor_email, task_executor_id, task_id) 
    @task.assigner.profile.first_name = task_assigner_first_name
    @task.assigner.profile.last_name = task_assigner_last_name
    @task.executor.profile.first_name = task_executor_first_name
    @task.executor.email = task_executor_email
    @task.executor_id = task_executor_id
    @task.id = task_id

    mail(from: 'faskyn@gmail.com',
         to: "#{task.executor.email}",
         subject: "[Faskyn] New task/favor from #{task.assigner.profile.first_name} #{task.assigner.profile.last_name}"
         )
  end
end