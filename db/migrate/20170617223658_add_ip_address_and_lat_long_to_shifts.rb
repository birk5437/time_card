class AddIpAddressAndLatLongToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :ip_address, :string
    add_column :shifts, :latitude, :float
    add_column :shifts, :longitude, :float
  end
end
