require 'rails_helper'

describe Task::Create do
  let(:outcome) { described_class.run(inputs) }
  let(:result) { outcome.result }
  let(:user) { create(:user) }
  let(:title)  { 'テストタスクタイトル' }
  let(:body) {  'テストタスク内容' }
  let(:inputs) {
    {
      user: user,
      title: title,
      body: body
    }
  }

  context 'inputがない場合' do
    let(:inputs) { {} }

    it { expect(outcome).to be_invalid }
    it { expect(outcome.errors).to be_present }
  end

  context 'タスクが空文字の場合' do
    let(:inputs) { { user: user, title: '', body: 'テストタスク内容' } }

    it { expect(outcome).to be_invalid }
    it { expect(outcome.errors.full_messages).to eq ['タイトルを入力してください'] }
  end

  context '#execute' do
    it 'タスクが登録できる' do
      expect(outcome).to be_valid
      expect(result.title).to eq 'テストタスクタイトル'
      expect(result.body).to eq 'テストタスク内容'
      task = Task.last
      expect(task.title).to eq 'テストタスクタイトル'
      expect(task.body).to eq 'テストタスク内容'
      expect(task.user).to eq user
    end
  end
end