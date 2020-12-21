class CreateTownships < ActiveRecord::Migration[5.2]
  def change
    create_table :townships do |t|
      t.string :name
      t.references :state, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
