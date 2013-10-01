class PostVote < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  attr_accessible :post, :post_id

  validates :post, :presence => true
  validates :user, :presence => true

  def self.record_one_vote(post, user)
    some_vote = PostVote.where("post_id = ? and user_id = ?",post, user)
    puts "vote post model"
    if some_vote.empty?
      new_vote = PostVote.new
      new_vote.user_id = user
      new_vote.post_id = post
      new_vote.save!
    end
  end
  def self.has_voted?(post, user)
    some_vote = PostVote.where("post_id = ? and user_id = ?",post, user)
    if some_vote.empty?
      false
    else true
    end
  end
end
