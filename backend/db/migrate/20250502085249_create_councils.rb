class CreateCouncils < ActiveRecord::Migration[7.0]
  def change
    create_table :councils do |t|
      t.string :name
      t.string :province
      t.string :population
      t.boolean :multi_tenant
      t.integer :puerto_org
      t.integer :puerto_proc_part
      t.text :collaborations, array: true, default: []
      t.text :services, array: true, default: []

      t.timestamps
    end
  end
end
