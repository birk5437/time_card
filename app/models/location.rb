class Location < ActiveRecord::Base

  serialize :ip_addresses, Array

  has_many :shifts

  def to_s
    "#{city}, #{state}"
  end
end
