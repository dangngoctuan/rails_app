class CreateAuthenticationTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :authentication_tokens do |t|
      t.references :user, index: true, foreign_key: true
      t.string :hashed_id

      t.timestamps
    end
    add_index :authentication_tokens, :hashed_id, unique: true
  end
end
