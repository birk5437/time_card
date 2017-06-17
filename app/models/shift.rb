class Shift < ActiveRecord::Base
  # http://www.sitepoint.com/ratyrate-add-rating-rails-app/
  belongs_to :user
  validates_presence_of :user

  geocoded_by :ip_address

  def nil_out_zero_lat_long
    if (latitude.blank? || longitude.blank?) || (latitude.zero? && longitude.zero?)
      self.latitude = nil
      self.longitude = nil
    end
  end

end
