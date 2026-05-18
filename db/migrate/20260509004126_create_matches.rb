class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.references :user_one, null: false, foreign_key: { to_table: :users }
      t.references :user_two, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :matches, [ :user_one_id, :user_two_id ], unique: true
    add_check_constraint :matches, "user_one_id < user_two_id", name: "user_order_check"
  end
end
