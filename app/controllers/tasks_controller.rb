class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :only_current_user
  before_action :if_no_profile_exists
  #before_action :other_user_profile_exists, only: :create
  before_action :set_task, only: [:show, :edit, :update, :delete, :destroy, :complete, :uncomplete]
  #before_action :set_assigner, only: :create
  #before_action :set_conversation, only: [:show]

  require 'will_paginate/array'

  def index
    #with no ransack
    #@tasks = current_user.tasks_uncompleted.paginate(page: params[:page], per_page: 12)
    #@tasks = current_user.assigned_and_executed_tasks.uncompleted.order("created_at DESC").paginate(page: params[:page], per_page: 12)
    #with ransack
    @q_tasks = Task.alltasks(current_user).uncompleted.ransack(params[:q])
    #eager loading --> @tasks = @q_tasks.result.includes(:executor_profile, :assigner_profile).order("deadline DESC").paginate(page: params[:page], per_page: 12)
    @tasks = @q_tasks.result.includes(:executor, :executor_profile, :assigner, :assigner_profile).order("deadline DESC").paginate(page: params[:page], per_page: Task.pagination_per_page)
    #for AJAX version
    @task = Task.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    if current_user.id == @task.assigner.id
      @assigned_task = current_user.assigned_tasks.find(params[:id])
    else
      @executed_task = current_user.executed_tasks.find(params[:id])
    end 
  end

  def outgoing_tasks
    #with no ransack (going back to this one when changing to jQuery search)
      #@assigned_tasks = current_user.assigned_tasks.uncompleted.order("deadline DESC").paginate(page: params[:page], per_page: 12)
    #ransack version for sorting
    @q_outgoing_tasks = current_user.assigned_tasks.uncompleted.ransack(params[:q])
    @tasks = @q_outgoing_tasks.result.includes(:executor, :executor_profile).order("deadline DESC").paginate(page: params[:page], per_page: Task.pagination_per_page)
    #for AJAX version
    @task = Task.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def incoming_tasks
    #with no ransack
      #@executed_tasks = current_user.executed_tasks.uncompleted.order("created_at DESC").paginate(page: params[:page], per_page: 12)
    #ransack version for sorting
    @q_incoming_tasks = current_user.executed_tasks.uncompleted.ransack(params[:q])
    @tasks = @q_incoming_tasks.result.includes(:assigner, :assigner_profile).order("deadline DESC").paginate(page: params[:page], per_page: Task.pagination_per_page)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    #check for other_user_profile_exists before filter (@task = Task.new(task_params))
    @task.assigner_id = current_user.id
    if @task.save
      TaskcreatorWorker.perform_async(@task.id, @user.id, 5) #sidekiq email on task creation
      Conversation.create(sender_id: @task.assigner_id, recipient_id: @task.executor_id)
      respond_to do |format|
        format.html { redirect_to user_tasks_path(current_user), notice: "Task saved!" }
        format.js
      end
      #sending in-app notification to executor; send_notification defined in notification.rb
      Notification.send_notification(@task.executor, "task", @task.assigner)
    else
      respond_to do |format|
        format.html { render action: :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def complete
    @task.update_attribute(:completed_at, Time.now)
    respond_to do |format|
      format.html { redirect_to completed_tasks_user_tasks_path(current_user), notice: "Task completed!" }
      format.js
    end
  end

  def uncomplete
    @task.update_attribute(:completed_at, nil)
    respond_to do |format|
      format.html { redirect_to user_tasks_path(current_user), notice: "Task uncompleted!" }
      format.js
    end
  end

  def completed_tasks
    #with no ransack
      #@tasks = @user.tasks_completed.paginate(page: params[:page], per_page: 12)
    #with ransack
    @q_completed_tasks = Task.alltasks(current_user).completed.ransack(params[:q])
    #@q_completed_tasks = current_user.tasks_completed.ransack(params[:q])
    @tasks = @q_completed_tasks.result.includes(:assigner, :assigner_profile, :executor, :executor_profile).paginate(page: params[:page], per_page: Task.pagination_per_page)
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
  end

  def update
    respond_to do |format|
      if @task.update_attributes(task_params)
        format.html { redirect_to user_tasks_path(current_user), notice: "Task was successfully updated!"}
        format.js
      else
        format.html { render action: :edit, alert: "Task couldn't be updated!"}
        format.js
      end
    end
  end

  def delete
  end

  def destroy
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
      params.require(:task).permit(:executor_id, :name, :content, :deadline, :task_name_company, :assigner_id, :executor_profile, :assigner_profile)
    end

    def set_task
      @task = Task.find(params[:id])
    end

    def set_assigner
      @task.assigner_id = current_user.id
    end
end