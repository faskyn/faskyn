class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @assigned_tasks = @user.assigned_tasks
    @executed_tasks = @user.executed_tasks
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
    @assigned_tasks = @user.assigned_tasks.order("created_at DESC")
  end

  def incoming_tasks
    @user =current_user
    @executed_tasks = @user.executed_tasks.order("created_at DESC")
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = "Task saved!"
      redirect_to user_tasks_path(current_user)
    else
      render action: :new
    end
  end

  def complete
    @task.update_attribute(:completed_at, Time.now)
  end

  def edit
  end

  def update
  end

  def delete
  end

  def destroy
  end

  private

    def task_params
      params.require(:task).permit(:executor_id, :name, :content, :deadline).merge(assigner_id: current_user.id)
    end


end