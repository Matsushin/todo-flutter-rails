require 'rails_helper'
describe Task::Delete do
  let(:outcome) { described_class.run(inputs) }
  let(:result) { outcome.result }
  let(:task) { create(:task, title: 'テストタスク') }
  let(:inputs) {
    {
      task: task
    }
  }
  context 'inputがない場合' do
    let(:inputs) { {} }
    it { expect(outcome).to be_invalid }
    it { expect(outcome.errors).to have_key :task }
  end

  context '#execute' do
    it 'タスクが削除されている' do

      expect(outcome).to be_valid
      expect(result).to eq task
      expect(Task.count).to eq 0
    end
  end
end