class User < ActiveRecord::Base

  DEFAULT_PASSWORD = "asdfg"

  ratyrate_rater
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_roles, dependent: :destroy, autosave: true
  has_many :roles, through: :user_roles, autosave: true

  has_many :shifts, dependent: :destroy

  belongs_to :created_by, :class_name => "User"

  validates :first_name, :pin, presence: true
  validates :pin, uniqueness: true

  validates :email, presence: true, :if => proc{ |u| u.admin? }

  before_validation :set_default_password


  def latest_shift
    shifts.order('clock_in_time desc').limit(1).first
  end

  # def hours_worked_this_week
  #   shifts.where(["clock_in_time >= ?", Date.today.beginning_of_week.beginning_of_day])
  # end

  def admin?
    roles.all.map(&:title).include?("admin")
  end

  def clocked_in?
    latest_shift = shifts.order('clock_in_time desc').limit(1).first
    latest_shift.present? && latest_shift.clock_out_time.blank?
  end

  def clocked_out?
    # latest_shift = shifts.order('clock_in_time desc').limit(1).first
    # latest_shift.blank? || latest_shift.clock_out_time.present?
    !clocked_in?
  end

  def clock_in!(ip_address=nil)
    if clocked_in?
      errors.add(:base, "Already clocked out!")
      raise ActiveRecord::RecordInvalid
    else
      s = shifts.build(clock_in_time: DateTime.now)
      s.ip_address = ip_address if ip_address.present?
      s.save!
    end
  end

  def clock_out!
    if clocked_out?
      errors.add(:base, "Already clocked out!")
      raise ActiveRecord::RecordInvalid
    else
      s = latest_shift
      s.clock_out_time = DateTime.now
      s.save!
    end
  end

  def name
    "#{first_name} #{last_name}".strip.presence
  end


  def role_symbols
    (roles || []).map {|r| r.title.to_sym}
  end

  def admin=(input)
    if input
      grant_role(:admin)
    else
      revoke_role(:admin)
    end
  end

  def superuser=(input)
    if input
      grant_role(:superuser)
    else
      revoke_role(:superuser)
    end
  end

  # TODO: Doesnt work
  def revoke_role(role_symbol)
    role_name = role_symbol.to_s.humanize.downcase
    if role_symbols.include?(role_symbol)
      role = Role.ci_find_by_name(role_name)
      ur = user_roles.find_by(role: role)
      ur.mark_for_destruction if ur.present?
    end    
  end

  def grant_role(role_symbol)
    role_name = role_symbol.to_s.humanize.downcase
    unless role_symbols.include?(role_symbol)
      role = Role.ci_find_by_name(role_name)
      self.user_roles.build(role: role)
    end
  end

  private

  def set_default_password
    if password.blank?
      password = DEFAULT_PASSWORD
      password_confirmation = DEFAULT_PASSWORD
    end
  end

end
