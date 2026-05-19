class RemoveNameFromCategories < ActiveRecord::Migration[8.1]
  def change
    remove_column :categories, :name, :string
  end
end
