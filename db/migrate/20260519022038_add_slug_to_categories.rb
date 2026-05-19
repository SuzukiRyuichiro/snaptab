class AddSlugToCategories < ActiveRecord::Migration[8.1]
  def change
    add_column :categories, :slug, :string
  end
end
