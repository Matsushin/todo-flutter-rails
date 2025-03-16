require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :request do
  let!(:user) { create(:user, email: 'yamada@example.com', password: 'password') }
  let!(:task) { create(:task, user: user, title: 'テストタスク1') }
  let!(:task2) { create(:task, user: user, title: 'テストタスク2') }
  let!(:task3) { create(:task, title: 'テストタスク3') }

  describe '.index' do
    it 'ログイン済みユーザが参照できるタスク一覧が取得できる' do
      login_user = { email: 'yamada@example.com', password: 'password' }
      auth_tokens = sign_in(login_user)
      get '/api/v1/tasks', headers: auth_tokens, as: :json
      expect(response).to have_http_status :ok

      body = JSON.parse(response.body)
      expect(body.count).to eq 2
      expect(body.first['title']).to eq 'テストタスク1'
      expect(body.second['title']).to eq 'テストタスク2'
    end

    it 'ログイン済みでない場合タスク一覧を取得できない' do
      get '/api/v1/tasks'
      expect(response).to have_http_status :unauthorized
    end
  end

  describe '.create' do
    it 'ログイン済みユーザがタスクを作成できる' do
      login_user = { email: 'yamada@example.com', password: 'password' }
      auth_tokens = sign_in(login_user)
      post '/api/v1/tasks', headers: auth_tokens, params: { task: { title: 'title', body: 'body' } }
      expect(response).to have_http_status :ok

      body = JSON.parse(response.body)
      expect(body['task']['title']).to eq 'title'
      expect(body['task']['user_id']).to eq 1
      expect(Task.count).to eq 4
      expect(Task.last).to have_attributes(title: 'title', user: user)
      expect(user.tasks.count).to eq 3
    end

    it 'ログイン済みでない場合ユーザはタスクを作成できない' do
      post '/api/v1/tasks', params: { task: { title: 'title' } }
      expect(response).to have_http_status :unauthorized
      expect(Task.count).to eq 3
      expect(user.tasks.count).to eq 2
    end

    it 'タスク名が空文字の場合タスクを作成できない' do
      login_user = { email: 'yamada@example.com', password: 'password' }
      auth_tokens = sign_in(login_user)
      post '/api/v1/tasks', headers: auth_tokens, params: { task: { title: "", body: 'body' } }
      expect(response).to have_http_status :bad_request
      expect(Task.count).to eq 3
      expect(user.tasks.count).to eq 2
    end
  end

  describe '.show' do
    it 'ログイン済みユーザが参照できるタスク詳細を取得できる' do
      login_user = { email: 'yamada@example.com', password: 'password' }
      auth_tokens = sign_in(login_user)
      get "/api/v1/tasks/#{task.id}", headers: auth_tokens, as: :json
      expect(response).to have_http_status :ok

      body = JSON.parse(response.body)
      expect(body['title']).to eq 'テストタスク1'
    end
  end

  describe '.update' do
    it 'ログイン済みユーザがタスクを更新できる' do
      login_user = { email: 'yamada@example.com', password: 'password' }
      auth_tokens = sign_in(login_user)
      patch "/api/v1/tasks/#{task.id}", headers: auth_tokens, params: { task: { title: 'title', body: 'body' } }
      expect(response).to have_http_status :ok

      body = JSON.parse(response.body)
      expect(body['task']['title']).to eq 'title'
      expect(body['task']['user_id']).to eq 1
    end

    it 'タスク名と内容が空文字の場合タスクを更新できない' do
      login_user = { email: 'yamada@example.com', password: 'password' }
      auth_tokens = sign_in(login_user)
      patch "/api/v1/tasks/#{task.id}", headers: auth_tokens, params: { task: { title: '' } }
      expect(response).to have_http_status :bad_request

      body = JSON.parse(response.body)
      expect(body['errors'].length).to eq 1
    end
  end

  describe '.destroy' do
    it 'ログイン済みユーザがタスクを削除できる' do
      login_user = { email: 'yamada@example.com', password: 'password' }
      auth_tokens = sign_in(login_user)
      delete "/api/v1/tasks/#{task.id}", headers: auth_tokens
      expect(response).to have_http_status :ok
      expect(Task.count).to eq 2
    end
  end
end
