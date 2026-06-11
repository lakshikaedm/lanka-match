class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.references :match, null: false, foreign_key: true, index: { unique: true }
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
