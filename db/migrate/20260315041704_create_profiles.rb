class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :display_name
      t.date :birth_date
      t.integer :gender
      t.text :bio
      t.string :location
      t.string :occupation

      t.timestamps
    end
  end
end
