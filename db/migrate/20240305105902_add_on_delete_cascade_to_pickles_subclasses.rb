class AddOnDeleteCascadeToPicklesSubclasses < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :ingredients, :pickles
    add_foreign_key :ingredients, :pickles, on_delete: :cascade

    remove_foreign_key :sauce_materials, :pickles
    add_foreign_key :sauce_materials, :pickles, on_delete: :cascade

    remove_foreign_key :journals, :pickles
    add_foreign_key :journals, :pickles, on_delete: :cascade
  end
end
