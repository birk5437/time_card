class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :city
      t.string :state
      t.string :zip
      t.string :ip_addresses
    end
    add_column :shifts, :location_id, :integer

    l = Location.new(city: "East Jordan", state: "MI", zip: "49727")
    l.save!
    l = Location.new(city: "Boyne City", state: "MI", zip: "49712")
    l.save!
    l = Location.new(city: "Petoskey", state: "MI", zip: "49770")
    l.save!
  end

  def self.down
    drop_table :locations
    remove_column :shifts, :location_id
  end
end
