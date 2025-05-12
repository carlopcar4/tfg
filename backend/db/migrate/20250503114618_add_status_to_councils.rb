class AddStatusToCouncils < ActiveRecord::Migration[7.0]
  def change
    add_column :councils, :status, :string
  end
end
