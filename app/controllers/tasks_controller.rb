class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :only_current_user
  before_action :if_no_profile_exists
  before_action :other_user_profile_exists, only: [:create]
  #before_action :set_conversation, only: [:show]

  require 'will_paginate/array'

  def index
    @assigned_tasks = current_user.assigned_tasks.uncompleted.order("created_at DESC")
    @executed_tasks = current_user.executed_tasks.uncompleted.order("created_at DESC")
    @tasks = current_user.tasks_uncompleted.paginate(page: params[:page], per_page: 12)
  end

  def show
    @task = Task.find(params[:id])
    if current_user.id == @task.assigner.id
      @assigned_task = current_user.assigned_tasks.find(params[:id])
    else
      @executed_task = current_user.executed_tasks.find(params[:id])
    end 
  end

  def outgoing_tasks
    @assigned_tasks = current_user.assigned_tasks.uncompleted.order("created_at DESC").paginate(page: params[:page], per_page: 12)
  end

  def incoming_tasks
    @executed_tasks = current_user.executed_tasks.uncompleted.order("created_at DESC").paginate(page: params[:page], per_page: 12)
  end

  def new
    @task = Task.new
  end

  def create
    #check for other_user_profile_exists before filter (@task = Task.new(task_params))
    if @task.save
      TaskcreatorWorker.perform_async(@task.id, @user.id, 5)
      flash[:success] = "Task saved!"
      Conversation.create(sender_id: @task.assigner_id, recipient_id: @task.executor_id)
      redirect_to user_tasks_path(current_user)
    else
      render action: :new
    end
  end

  def complete
    @task = Task.find(params[:id])
    @task.update_attribute(:completed_at, Time.now)
    redirect_to completed_tasks_user_tasks_path(current_user)
  end

  def uncomplete
    @task = Task.find(params[:id])
    @task.update_attribute(:completed_at, nil)
    redirect_to user_tasks_path(current_user)
  end

  def completed_tasks
    @assigned_tasks = current_user.assigned_tasks.completed.order("completed_at DESC")
    @executed_tasks = current_user.executed_tasks.completed.order("completed_at DESC")
    @tasks = @user.tasks_completed.paginate(page: params[:page], per_page: 12)
  end

  def completed_incoming_tasks
    @executed_tasks = current_user.executed_tasks.completed.order("completed_at DESC")
  end

  def completed_outgoing_tasks
    @assigned_tasks = current_user.assigned_tasks.completed.order("completed_at DESC")
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
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
    @task = Task.find(params[:id])
    if current_user.id == @task.assigner.id
      @task = current_user.assigned_tasks.find(params[:id])
    else
      @task = current_user.executed_tasks.find(params[:id])
    end
    if @task.destroy
      flash[:success] = "Task was deleted"
    else
      flash[:error] = "Task could not be deleted"
    end
    if current_user == @task.assigner.id
      redirect_to outgoing_tasks_user_tasks_path(current_user)
    else
      redirect_to incoming_tasks_user_tasks_path(current_user)
    end
  end

  private

    def task_params
      params.require(:task).permit(:executor_id, :name, :content, :deadline, :task_name_company).merge(assigner_id: current_user.id)
    end

    def only_current_user
      @user = User.find(params[:user_id])
      redirect_to user_tasks_path(current_user) unless @user == current_user
    end

end