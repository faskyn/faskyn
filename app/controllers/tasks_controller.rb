class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_authorize_user_tasks, only: [:index, :outgoing_tasks, :incoming_tasks, :completed_tasks, :completed_incoming_tasks, :completed_outgoing_tasks]
  before_action :set_user, only: [:new, :show, :edit, :update, :delete, :destroy, :complete, :uncomplete]
  before_action :set_and_authorize_task, only: [:show, :edit, :update, :delete, :destroy, :complete, :uncomplete]

  require 'will_paginate/array'

  def index
    @q_tasks = Task.alltasks(current_user).uncompleted.ransack(params[:q])
    #eager loading --> @tasks = @q_tasks.result.includes(:executor_profile, :assigner_profile).order("deadline DESC").paginate(page: params[:page], per_page: 12)
    @tasks = @q_tasks.result.includes(:executor, :executor_profile, :assigner, :assigner_profile).order("created_at DESC").paginate(page: params[:page], per_page: Task.pagination_per_page)
    @task = Task.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
  end

  def outgoing_tasks
    @q_outgoing_tasks = current_user.assigned_tasks.uncompleted.ransack(params[:q])
    @tasks = @q_outgoing_tasks.result.includes(:executor, :executor_profile).order("created_at DESC").paginate(page: params[:page], per_page: Task.pagination_per_page)
    @task = Task.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def incoming_tasks
    #@executed_tasks = current_user.executed_tasks.uncompleted.order("created_at DESC").paginate(page: params[:page], per_page: 12)
    @q_incoming_tasks = current_user.executed_tasks.uncompleted.ransack(params[:q])
    @tasks = @q_incoming_tasks.result.includes(:assigner, :assigner_profile).order("created_at DESC").paginate(page: params[:page], per_page: Task.pagination_per_page)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @user = User.find(params[:user_id])
    authorize @user, :new_task?
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.assigner_id = current_user.id
    if @task.save
      TaskCreatorJob.perform_later(@task.id, @user.id)
      Conversation.create(sender_id: @task.assigner_id, recipient_id: @task.executor_id)
      Notification.send_notification(@task.executor, "task", @task.assigner)
      respond_to do |format|
        format.html { redirect_to user_tasks_path(current_user), notice: "Task saved!" }
        format.js
      end     
    else
      respond_to do |format|
        format.html { render action: :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def complete
    @task.update_attribute(:completed_at, Time.zone.now)
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

    def set_and_authorize_user_tasks
      @user = User.find(params[:user_id])
      authorize @user, :show_tasks?
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_and_authorize_task
      @task = Task.find(params[:id])
      authorize @task
    end
end