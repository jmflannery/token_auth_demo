class CreateTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens do |t|
      t.references :user
      t.string :key, length: 64

      t.timestamps
    end
  end
end
