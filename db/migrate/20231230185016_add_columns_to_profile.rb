class AddColumnsToProfile < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :description, :text, limit: 160
    add_column :profiles, :x_username, :text
    add_column :profiles, :ig_username, :text
  end
end
