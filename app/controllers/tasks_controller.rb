class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :only_current_user
  before_action :if_no_profile_exists
  before_action :other_user_profile_exists, only: [:create]

  require 'will_paginate/array'

  def index
    @user = current_user
    #@tasks = @user.indextasks.uncompleted
    #@tasks = @user.tasks #defined in model
    #@tasks = current_user.tasks
    @assigned_tasks = @user.assigned_tasks.uncompleted.order("created_at DESC")
    @executed_tasks = @user.executed_tasks.uncompleted.order("created_at DESC")
    #@tasks = @user.alltasks(current_user).uncompleted
    @tasks = @user.tasks_uncompleted.paginate(page: params[:page], per_page: 12)
    #@q = Task.search(params[:q])
    #@tasks = @q.result.tasks_uncompleted
  end

  def show
    @user = current_user
    @task = Task.find(params[:id])
    if @user.id == @task.assigner.id
      @assigned_task = @user.assigned_tasks.find(params[:id])
    else
      @executed_task = @user.executed_tasks.find(params[:id])
    end 
  end

  def outgoing_tasks
    @user = current_user
    @assigned_tasks = @user.assigned_tasks.uncompleted.order("created_at DESC").paginate(page: params[:page], per_page: 12)
  end

  def incoming_tasks
    @user =current_user
    @executed_tasks = @user.executed_tasks.uncompleted.order("created_at DESC").paginate(page: params[:page], per_page: 12)
  end

  def new
    @user = current_user
    @task = Task.new
  end

  def create
    @user = current_user
    #check for other_user_profile_exists before filter (@task = Task.new(task_params))
    if @task.save
      #@assigner = @task.assigner
      #h = JSON.generate({ 'name' => @assigner.profile.name })
      h = JSON.generate( {'task_assigner_first_name' => @current_user.profile.first_name,
                          'task_assigner_last_name' => @current_user.profile.last_name,
                          'task_executor_first_name' => @task.executor.profile.first_name,
                          'task_executor_email' => @task.executor.email,
                          'task_executor_id' => @task.executor_id,
                          'task_id' => @task.id
                           } )
      TaskcreatorWorker.perform_async(h, 5)
      #TaskMailer.task_created(current_user, @task).deliver_later
      flash[:success] = "Task saved!"
      redirect_to user_tasks_path(current_user)
    else
      render action: :new
    end
  end

  def complete
    @user = current_user
    @task = Task.find(params[:id])
    @task.update_attribute(:completed_at, Time.now)
    redirect_to completed_tasks_user_tasks_path(current_user)
  end

  def uncomplete
    @user = current_user
    @task = Task.find(params[:id])
    @task.update_attribute(:completed_at, nil)
    redirect_to user_tasks_path(current_user)
  end

  def completed_tasks
    @user = current_user
    @assigned_tasks = @user.assigned_tasks.completed.order("completed_at DESC")
    @executed_tasks = @user.executed_tasks.completed.order("completed_at DESC")
    @tasks = @user.tasks_completed.paginate(page: params[:page], per_page: 12)
  end

  def completed_incoming_tasks
    @user = current_user
    @executed_tasks = @user.executed_tasks.completed.order("completed_at DESC")
  end

  def completed_outgoing_tasks
    @user = current_user
    @assigned_tasks = @user.assigned_tasks.completed.order("completed_at DESC")
  end

  def edit
    @user = current_user
    @task = Task.find(params[:id])
  end

  def update
    @user = current_user
    @task = Task.find(params[:id])
    if @task.update_attributes(task_params)
      flash[:success] = "Task updated!"
      redirect_to user_tasks_path(current_user)
    else
      render action: :edit
    end
  end

  def delete
  end

  def destroy
    @user = current_user
    @task = Task.find(params[:id])
    if @user.id == @task.assigner.id
      @task = @user.assigned_tasks.find(params[:id])
    else
      @task = @user.executed_tasks.find(params[:id])
    end
    if @task.destroy
      flash[:success] = "Task was deleted"
    else
      flash[:error] = "Task could not be deleted"
    end
    if @user.id == @task.assigner.id
      redirect_to outgoing_tasks_user_tasks_path(current_user)
    else
      redirect_to incoming_tasks_user_tasks_path(current_user)
    end
  end

  private

    def task_params
      params.require(:task).permit(:executor_id, :name, :content, :deadline).merge(assigner_id: current_user.id)
    end

    def only_current_user
      @user = User.find(params[:user_id])
      redirect_to user_tasks_path(current_user) unless @user == current_user
    end

end