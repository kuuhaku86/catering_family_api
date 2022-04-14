class CreateMenusCategories < ActiveRecord::Migration[7.0]
  create_table :menus_categories, id: false do |t|
    t.belongs_to :menus
    t.belongs_to :categories
  end
end
