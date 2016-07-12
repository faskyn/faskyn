class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_authorize_user_tasks, only: [:index, :outgoing_tasks, :incoming_tasks, :completed_tasks, :completed_incoming_tasks, :completed_outgoing_tasks]
  before_action :set_user, only: [:create, :edit, :update, :destroy, :uncomplete]
  before_action :set_and_authorize_task, only: [:edit, :update, :destroy, :complete, :uncomplete]
  #after_action { flash.discard if request.xhr? }, only: :create

  require 'will_paginate/array'

  def index
    #@tasks = Task.alltasks(current_user).uncompleted.includes(:executor, :executor_profile, :assigner, :assigner_profile).order("created_at DESC").paginate(page: params[:page], per_page: Task.pagination_per_page)
    @tasks = Task.alltasks(current_user).index_default
    respond_to do |format|
      format.html
      format.js
    end
  end

  def outgoing_tasks
    # @tasks = current_user.assigned_tasks.uncompleted.includes(:executor, :executor_profile).order("created_at DESC").paginate(page: params[:page], per_page: Task.pagination_per_page)
    @tasks = current_user.assigned_tasks.assigned_default(page: params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def incoming_tasks
    # @tasks = current_user.executed_tasks.uncompleted.includes(:assigner, :assigner_profile).order("created_at DESC").paginate(page: params[:page], per_page: Task.pagination_per_page)
    @tasks = current_user.executed_tasks.executed_default(page: params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @task = Task.new(task_params)
    authorize @task
    @task.assigner_id = current_user.id
    if @task.save
      Notification.create(recipient_id: @task.executor_id, sender_id: current_user.id, notifiable: @task, action: "assigned")
      TaskCreatorJob.perform_later(@task.id)
      respond_to do |format|
        format.js { flash.now[:notice] = "Message sent!" }
      end     
    else
      respond_to do |format|
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
    #@tasks = Task.alltasks(current_user).completed.includes(:assigner, :assigner_profile, :executor, :executor_profile).order(completed_at: :desc).paginate(page: params[:page], per_page: Task.pagination_per_page)
    @tasks = Task.alltasks(current_user).completed_default(page: 1)
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
    respond_to :js
  end

  def update
    respond_to do |format|
      if @task.update_attributes(task_params)
        format.js
      else
        format.js
      end
    end
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
      params.require(:task).permit(:executor_id, :name, :content, :task_name_company, :assigner_id, :executor_profile, :assigner_profile)
    end

    def set_and_authorize_user_tasks
      @user = User.find(params[:user_id])
      authorize @user, :index_tasks?
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_and_authorize_task
      @task = Task.find(params[:id])
      authorize @task
    end
end