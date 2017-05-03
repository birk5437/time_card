class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.references :user
      t.datetime :clock_in_time
      t.datetime :clock_out_time
      t.timestamps
    end
  end
end
