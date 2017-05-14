class CreateBasicRoles < ActiveRecord::Migration

  ROLE_NAMES = ["admin", "barista", "manager", "superuser"]

  def self.up
    ROLE_NAMES.each do |role_name|
      r = Role.new(title: role_name)
      r.save!
    end
  end

  def self.down
    ROLE_NAMES.each do |role_name|
      Role.where(title: role_name).map(&:destroy)
    end
  end

end
