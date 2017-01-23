class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|
      t.text :text
      t.references :employment, foreign_key: true

      t.timestamps
    end
  end
end
