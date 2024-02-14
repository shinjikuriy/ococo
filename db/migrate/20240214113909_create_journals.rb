class CreateJournals < ActiveRecord::Migration[7.1]
  def change
    create_table :journals do |t|
      t.belongs_to :pickle, null: false, foreign_key: true
      t.string :body

      t.timestamps
    end
  end
end
