class AddDisplayNameToCategories < ActiveRecord::Migration[8.1]
  def change
    add_column :categories, :display_name, :string
  end
end
