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

  def clocked_in?
    shifts.order(:clock_in_time).last.try(:clock_out_time).blank?
  end
end
