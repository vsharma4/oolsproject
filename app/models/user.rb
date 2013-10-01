class User < ActiveRecord::Base
  attr_accessible :admin, :email, :name, :password
  has_many :posts
  has_many :comments
  has_many :post_votes
  has_many :comment_votes

  validates_length_of :password, :within => 8..20
  validates :email , :presence => true, uniqueness: { case_sensitive: false }
  validates :password , :presence => true
  validates :name, :presence => true
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "-email format incorrect"

  def self.authenticate(email, pass)
    u = User.find_by_email(email)
    return nil if u.nil?
    return u if pass == u.password
    nil
  end

  def self.is_Admin?(user)
    admin = User.where("id = ? and admin = 't'",user)
    if admin.empty?
      false
    else
      true
    end
  end
end
