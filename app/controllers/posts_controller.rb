class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @user = current_user
    @post = Post.new
  end

  def create
    @post = Post.create(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to posts_url
  end

  def edit
    @post = Post.find_by(id: params[:id])
    validate_owner
  end

  def update
    post = Post.find_by(id: params[:id])
    post.update_time_check
    post.update(message: params[:post])
    redirect_to posts_url
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    
    if current_user.id != @post.user_id
      # this will work, but refreshes the page and puts the message at the top
      redirect_to posts_url, notice: "Oops, that's not your post!" 
      # # this could work, but needs to be extracted and drawn on the post
      # flash.now[:alert] = {post: params[:id], message: "Oops, that's not your post!"}
      # print("flash hash: "); puts(flash[:alert])

      # we could also skip this statement, by validating the from in JS
      # i.e. when the user logs in, we add their user id to the cookies,
      # we add the creater's id to post, and we have a javascript function
      # that checks the user_id === create_id when the button is clicked
      # https://stackoverflow.com/questions/29737384/accessing-current-user-variable-from-application-js-in-rails-3
    else
      @post.destroy
      redirect_to posts_url
    end
  end

  private

  def post_params
    params.require(:post).permit(:message)
  end

  def validate_owner
    redirect_to posts_url, notice: "Oops, that's not your post!" if current_user.id != @post.user_id
  end
end
