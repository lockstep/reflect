class AddEmployeeInfoToEmployments < ActiveRecord::Migration[5.0]
  def change
    add_column :employments, :email, :string
    add_column :employments, :slack_handle, :string
  end
end
