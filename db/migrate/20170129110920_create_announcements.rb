class CreateAnnouncements < ActiveRecord::Migration[5.0]
  def change
    create_table :announcements do |t|
      t.references :company, foreign_key: true
      t.text :text

      t.timestamps
    end
  end
end
