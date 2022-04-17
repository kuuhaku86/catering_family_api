class AlterTableMenusAddSoftDeleted < ActiveRecord::Migration[7.0]
  def change
    add_column :menus, :soft_deleted, :boolean, :default => false
  end
end
