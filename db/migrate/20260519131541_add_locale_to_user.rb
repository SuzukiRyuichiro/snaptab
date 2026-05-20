class AddLocaleToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :locale, :string
  end
end
