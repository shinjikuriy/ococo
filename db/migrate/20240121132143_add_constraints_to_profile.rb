class AddConstraintsToProfile < ActiveRecord::Migration[7.1]
  def change
    remove_index :profiles, :user_id
    add_index :profiles, :user_id, unique: true
  end
end
