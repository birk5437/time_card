class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  def self.ci_find_by_name(name)
    Role.where(["lower(title) = ?", name.downcase]).first
  end
end
