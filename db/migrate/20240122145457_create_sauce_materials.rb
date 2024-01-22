class CreateSauceMaterials < ActiveRecord::Migration[7.1]
  def change
    create_table :sauce_materials do |t|
      t.belongs_to :pickle, null: false, foreign_key: true
      t.string :name
      t.string :quantity

      t.timestamps
    end
  end
end
