class Shift < ActiveRecord::Base
  # http://www.sitepoint.com/ratyrate-add-rating-rails-app/
  belongs_to :user
  validates_presence_of :user

end
