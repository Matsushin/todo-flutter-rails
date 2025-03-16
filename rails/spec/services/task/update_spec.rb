require 'rails_helper'

describe Task::Update do
  let(:outcome) { described_class.run(inputs) }
  let(:result) { outcome.result }
  let(:task) { create(:task, title: 'テストタスク') }
  let(:title)  { 'テスト2タスク' }
  let(:inputs) {
    {
      task: task,
      title: title
    }
  }

  context 'inputがない場合' do
    let(:inputs) { {} }

    it { expect(outcome).to be_invalid }
    it { expect(outcome.errors).to have_key :task }
  end

  context 'タスクが空文字の場合' do
    let(:inputs) { { task: task, title: '' } }

    it { expect(outcome).to be_invalid }
    it { expect(outcome.errors.full_messages).to eq [ 'タイトルを入力してください' ] }
  end

  context '#execute' do
    it 'タスク名が更新できる' do
      expect(outcome).to be_valid
      expect(result.title).to eq 'テスト2タスク'
      expect(task.title).to eq 'テスト2タスク'
    end
  end
end
