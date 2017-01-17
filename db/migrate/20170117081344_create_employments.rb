class CreateEmployments < ActiveRecord::Migration[5.0]
  def change
    create_table :employments do |t|
      t.references :company, foreign_key: true
      t.references :user, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
