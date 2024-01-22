class AddColumnsToPickle < ActiveRecord::Migration[7.1]
  def change
    add_column :pickles, :preparation, :text
    add_column :pickles, :process, :text
    add_column :pickles, :note, :text
  end
end
