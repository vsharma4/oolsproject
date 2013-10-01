class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  has_many :comment_votes, :dependent => :destroy
  attr_accessible :description, :post, :post_id

  validates :post, :presence => true
  validates :user, :presence => true
  validates :description, :presence => true

  #checks if user is an owner of the comment
  def self.is_owner?(comment, user)
    some_comment = Comment.where("id = ? and user_id = ?",comment, user)
    if some_comment.empty?
      false
    else
      true
    end
  end
end
