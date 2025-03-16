class Api::V1::TasksController < Api::V1::ApplicationController
  before_action :set_task, only: %i[update show destroy]

  def index
    tasks = current_user.tasks.order(:created_at)
    render json: tasks.to_json
  end

  def create
    outcome = Task::Create.run(task_params.merge(user: current_user))

    if outcome.valid?
      render json: { task: outcome.result, errors: [] }
    else
      render json: { errors: outcome.errors.full_messages }, status: :bad_request
    end
  end

  def update
    outcome = Task::Update.run(task_params.merge(task: @task))

    if outcome.valid?
      render json: { task: outcome.result, errors: [] }
    else
      render json: { errors: outcome.errors.full_messages }, status: :bad_request
    end
  end

  def show
    render json: @task.to_json
  end

  def destroy
    outcome = Task::Delete.run(task: @task)
    if outcome.valid?
      render json: { task: outcome.result, errors: [] }
    else
      render json: { errors: outcome.errors.full_messages }, status: :bad_request
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :body)
  end
end
