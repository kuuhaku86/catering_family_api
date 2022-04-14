class CreateMenusCategories < ActiveRecord::Migration[7.0]
  create_table :menus_categories do |t|
    t.belongs_to :menus
    t.belongs_to :categories
  end

  add_index :menus_categories, [:menu_id, :category_id], unique: true
end
