class CreateExpenses < ActiveRecord::Migration[8.1]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.date :spent_at
      t.string :description
      t.decimal :amount
      t.string :currency

      t.timestamps
    end
  end
end
