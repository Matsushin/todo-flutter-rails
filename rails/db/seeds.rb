ActiveRecord::Base.transaction do
  if User.count.zero?
    User.create!(provider: 'email', uid: 'test@example.com', name: 'yamada', email: 'test@example.com', password: 'password')
  end
end