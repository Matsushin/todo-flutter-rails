class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :user, foreign_key: true
      t.string :title, null: false
      t.string :body
      t.datetime :completed_at

      t.timestamps
    end
  end
end
