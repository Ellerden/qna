class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :question, foreign_key: true
      t.references :author, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :subscriptions, [:author_id, :question_id]
  end
end
