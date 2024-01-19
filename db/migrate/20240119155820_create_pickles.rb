class CreatePickles < ActiveRecord::Migration[7.1]
  def change
    create_table :pickles do |t|
      t.belongs_to :user
      t.string :name
      t.date :started_on

      t.timestamps
    end
  end
end
