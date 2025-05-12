class AddDecidimProcessIdToCouncils < ActiveRecord::Migration[7.0]
  def change
    add_column :councils, :decidim_process_id, :integer
  end
end
