class Task::Create < ApplicationService
  object :user, default: nil
  string :title, default: nil
  string :body, default: nil

  validates :user, presence: true

  def execute
    task = Task.new(inputs)
    errors.merge!(task.errors) unless task.save
    task
  end
end
