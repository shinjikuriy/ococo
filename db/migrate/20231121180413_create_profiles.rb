class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.belongs_to :user
      t.string :display_name, limit: 30
      t.integer :prefecture, default: 0, null: false

      t.timestamps
    end
    add_index :profiles, :prefecture
  end
end
