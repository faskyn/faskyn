class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :only_current_user
  before_action :if_no_profile_exists
  before_action :other_user_profile_exists, only: :create
  before_action :set_assigner, only: :create
  #before_action :set_conversation, only: [:show]

  require 'will_paginate/array'

  def index
    @assigned_tasks = current_user.assigned_tasks.uncompleted.order("created_at DESC")
    @executed_tasks = current_user.executed_tasks.uncompleted.order("created_at DESC")
    @tasks = current_user.tasks_uncompleted.paginate(page: params[:page], per_page: 12)
    #for AJAX version
    @task = Task.new
    #respond_to do |format|
      #format.html
      #format.js
    #end
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
    #for AJAX version
    @task = Task.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def incoming_tasks
    @executed_tasks = current_user.executed_tasks.uncompleted.order("created_at DESC").paginate(page: params[:page], per_page: 12)
  end

  def new
    @task = Task.new
  end

  def create
    #check for other_user_profile_exists before filter (@task = Task.new(task_params))
    if @task.save || @task_between.save
      TaskcreatorWorker.perform_async(@task.id, @user.id, 5)
      Conversation.create(sender_id: @task.assigner_id, recipient_id: @task.executor_id)
      respond_to do |format|
        format.html { redirect_to user_tasks_path(current_user), notice: "Task saved!"}
        format.json { render action: 'show', status: :created, location: @person }
        format.js #{ render action: 'show', status: :created, location: @person }
      end
    else
      respond_to do |format|
        format.html { render action: :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
        format.js #{ render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def complete
    @task = Task.find(params[:id])
    @task.update_attribute(:completed_at, Time.now)
    respond_to do |format|
      format.html { redirect_to completed_tasks_user_tasks_path(current_user), notice: "Task completed!" }
      format.js
    end
  end

  def uncomplete
    @task = Task.find(params[:id])
    @task.update_attribute(:completed_at, nil)
    respond_to do |format|
      format.html { redirect_to user_tasks_path(current_user), notice: "Task uncompleted!" }
      format.js
    end
  end

  def completed_tasks
    @assigned_tasks = current_user.assigned_tasks.completed.order("completed_at DESC")
    @executed_tasks = current_user.executed_tasks.completed.order("completed_at DESC")
    @tasks = @user.tasks_completed.paginate(page: params[:page], per_page: 12)
    respond_to do |format|
      format.html
      format.js
    end
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
    respond_to do |format|
      if @task.update_attributes(task_params)
        format.html { redirect_to user_tasks_path(current_user), notice: "Task was successfully updated!"}
        format.js
      else
        format.html { render action: :edit}
        format.js
      end
    end
  end

  def delete
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      respond_to do |format|
        format.html { redirect_to user_tasks_path(current_user), notice: "Task got deleted!"}
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to user_tasks_path(current_user), notice: "Task couldn't be deleted!"}
        format.js
      end
    end
  end

  private

    def task_params
      params.require(:task).permit(:executor_id, :name, :content, :deadline, :task_name_company, :assigner_id)
    end

    def only_current_user
      @user = User.find(params[:user_id])
      redirect_to user_tasks_path(current_user) unless @user == current_user
    end

    def set_assigner
      @task.assigner_id = current_user.id
    end

end