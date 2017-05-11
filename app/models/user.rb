class User < ActiveRecord::Base

  DEFAULT_PASSWORD = "asdfg"

  ratyrate_rater
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :items, as: :created_by, foreign_key: :created_by_id, dependent: :nullify
  has_many :shifts

  belongs_to :created_by, :class_name => "User"


  def latest_shift
    shifts.order('clock_in_time desc').limit(1).first
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

  def clock_in!
    if clocked_in?
      errors.add(:base, "Already clocked out!")
      raise ActiveRecord::RecordInvalid
    else
      s = shifts.build(clock_in_time: DateTime.now)
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

end
