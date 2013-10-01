class CommentVote < ActiveRecord::Base
  belongs_to :comment
  belongs_to :user
  attr_accessible :comment, :comment_id

  validates :comment, :presence => true
  validates :user, :presence => true

  def self.record_one_vote(comment, user)
    some_vote = CommentVote.where("comment_id = ? and user_id = ?", comment, user)
    puts "vote comment model"
    if some_vote.empty?
      new_vote = CommentVote.new
      new_vote.user_id = user
      new_vote.comment_id = comment
      new_vote.save!
    end
  end

  def self.has_voted? (comment_id, user)
    some_vote = CommentVote.where("comment_id = ? and user_id = ?",comment_id, user)
    if some_vote.empty?
      false
    else true
    end
  end
end
