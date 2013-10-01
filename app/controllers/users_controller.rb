class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    result = User.find(:all)

    if result.empty?
      @user.admin = true
    end

    respond_to do |format|
      if @user.name =~ /^anonymous$/i
        #checks to disallow creating a user as anonymous
        @user.errors.add(:name,"-anonymous is a reserved username")
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      else
        if @user.save
          session[:user_id] = @user.id
          format.html { redirect_to posts_path, notice: 'User was successfully created.' }
        else
          format.html { render action: "new" }
        end
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def upgrade_to_admin
    @user = User.find(params[:id])
    @user.admin = true

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'User upgraded to admin.' }
        format.json { head :no_content }
      else
        format.html { redirect_to users_path }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def downgrade_to_admin
    @user = User.find(params[:id])
    @user.admin = false

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'User downgraded to simple user.' }
        format.json { head :no_content }
      else
        format.html { redirect_to users_path }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def delete_account
    @user = User.find(params[:id])
    session[:user_id] = nil

    anon = User.find_by_name("anonymous")

    ###### Update related Posts ######
    temp = Post.find_all_by_user_id(@user.id)
    temp.each do |post|
      post.user_id = anon.id
      post.save
    end

    ###### Update related Comments ######
    temp = Comment.find_all_by_user_id(@user.id)
    temp.each do |comment|
      comment.user_id = anon.id
      comment.save
    end

    ###### Update related Post Votes ######
    temp = PostVote.find_all_by_user_id(@user.id)
    temp.each do |postv|
      postv.user_id = anon.id
      postv.save
    end

    ###### Update related Comment Votes ######
    temp = CommentVote.find_all_by_user_id(@user.id)
    temp.each do |cvotes|
      cvotes.user_id = anon.id
      cvotes.save
    end

    respond_to do |format|
      if @user.destroy
      format.html { redirect_to  root_url, notice: "Account deleted successfully!" }
      format.json { head :no_content }
      else
        format.html { redirect_to users_path }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
    end

end
