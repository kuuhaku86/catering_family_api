class AlterTableCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :soft_deleted, :boolean, :default => false
  end
end
