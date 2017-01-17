class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.text :text
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
