class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all(:order => 'updated_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @vote_post = PostVote.where("post_id = ?",params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end


  def record_votes
    @post = Post.find(params[:id])
    uname = current_user
    some_vote = PostVote.where("post_id = ? and user_id = ?",params[:id], uname.id)

    if some_vote.empty?
      PostVote.record_one_vote(params[:id], uname.id)

      #to order the posts according to latest comment activity
      @post.updated_at = Time.now
      @post.save!
      flash[:login_error] = "Thank you for voting for the post."
    else
      flash[:login_error] = "Your vote for post is already registered."
    end
    redirect_to @post
  end

  def record_comment_votes
    @post = Post.find(params[:post_id])
    uname = current_user
    some_vote = CommentVote.where("comment_id = ? and user_id = ?",params[:id], uname.id)

    if some_vote.empty?
      CommentVote.record_one_vote(params[:id], uname.id)

      #to order the posts according to latest comment activity
      @post.updated_at = Time.now
      @post.save!
      flash[:login_error] = "Thank you for voting for the comment."
    else
      flash[:login_error] = "Your vote on comment is already registered."

    end
    redirect_to @post
  end

  def report
    @posts = Post.all
  end

  # shows posts when no user is logged in
  def show_posts_unlogged
    @post = Post.find(params[:id])
    @vote_post = PostVote.where("post_id = ?",params[:id])
  end
end
