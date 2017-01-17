class AddSlackIdToEmployments < ActiveRecord::Migration[5.0]
  def change
    add_column :employments, :slack_id, :string
  end
end
