class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :is_self?
  helper_method :has_user_voted_on_post?
  helper_method :has_user_voted_on_comment?

  private

  #returns currently logged in user based on session id
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  #checks if the user record supplied in the parameter is same as the user currently logged in
  def is_self?(user)
    if current_user and current_user.id == user
      true
    else
      false
    end
  end

  #checks if the user has already voted on a comment
  def has_user_voted_on_comment?(comment_id)
    some_vote = CommentVote.where("comment_id = ? and user_id = ?", comment_id, current_user.id)
    puts "comment id and user id ", comment_id, current_user.id, some_vote.empty?
    if some_vote.empty?
      false
    else
      true
    end
  end

  #checks if the user has already voted on a post
  def has_user_voted_on_post?(post_id)
    some_vote = PostVote.where("post_id = ? and user_id = ?", post_id, current_user.id)
    puts "post id and user id ", post_id, current_user.id, some_vote.empty?
    if some_vote.empty?
      false
    else
      true
    end
  end




end
