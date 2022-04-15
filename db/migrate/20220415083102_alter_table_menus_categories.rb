class AlterTableMenusCategories < ActiveRecord::Migration[7.0]
  def change
    rename_table :menus_categories, :categories_menus

    rename_column :categories_menus, :categories_id, :category_id
    rename_column :categories_menus, :menus_id, :menu_id
  end
end
