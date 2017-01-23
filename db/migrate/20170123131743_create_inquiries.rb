class CreateInquiries < ActiveRecord::Migration[5.0]
  def change
    create_table :inquiries do |t|
      t.references :question, foreign_key: true
      t.references :employment, foreign_key: true
      t.datetime :to_be_delivered_at
      t.datetime :delivered_at

      t.timestamps
    end
  end
end
