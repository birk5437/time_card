class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name
      t.timestamps
    end
    add_column :users, :business_id, :integer
  end
end
