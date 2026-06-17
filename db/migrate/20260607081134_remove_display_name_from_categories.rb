class RemoveDisplayNameFromCategories < ActiveRecord::Migration[8.1]
  def change
    remove_column :categories, :display_name, :string
  end
end
