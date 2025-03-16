ActiveRecord::Base.transaction do
  if User.count.zero?
    User.create!(provider: 'email', uid: 'test@example.com', name: 'yamada', email: 'test@example.com', password: 'password')
  end

  if Task.count.zero?
    user = User.first
    user.tasks.create!(title: 'タスク1', body: 'タスク1本文')
    user.tasks.create!(title: 'タスク2', body: 'タスク2本文')
    user.tasks.create!(title: 'タスク3', body: 'タスク3本文', completed_at: Time.current)
  end
end
