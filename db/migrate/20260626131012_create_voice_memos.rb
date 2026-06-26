class CreateVoiceMemos < ActiveRecord::Migration[8.1]
  def change
    create_table :voice_memos do |t|
      t.references :user, null: false, foreign_key: true
      t.references :expense, null: true, foreign_key: true
      t.string :status, null: false, default: "pending"
      t.text :transcript
      t.text :error_message

      t.timestamps
    end
  end
end
