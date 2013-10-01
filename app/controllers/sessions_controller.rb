class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to posts_path
    end
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      if User.is_Admin?(user.id)
        redirect_to posts_path, :notice => 'Welcome Admin!!'
      else
        redirect_to posts_path, :notice => 'Welcome!!'
      end
    else
      flash.now.alert = "Invalid email or password!"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "You have been signed out successfully!"
  end

  def show
  end


  def search_results
    if !params[:search].nil? and !params[:radio].nil?
      if params[:radio] == "content"
        @content = Post.search_by_content(params[:search])
      elsif params[:radio] == "category"
          @content = Post.search_by_category(params[:search])
      elsif params[:radio] == "user"
          @content = Post.search_by_user(params[:search])
      elsif params[:radio] == "tags"
          @content = Post.search_by_tag(params[:search])
      end
    else
      redirect_to '/show', :notice => "Search criteria missing!"
    end
  end
end
