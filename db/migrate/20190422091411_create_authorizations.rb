class CreateAuthorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :authorizations do |t|
      t.references :user, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :linked_email
      # confirmations
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      t.timestamps
    end

    add_index :authorizations, [:provider, :uid]
    add_index(:authorizations, [:provider, :uid, :linked_email], unique: true)
  end
end
