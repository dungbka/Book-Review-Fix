class CommentsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    commentable = commentable_type.constantize.find(commentable_id)
    @comment = Comment.build_from(commentable, current_user.id, body)

    respond_to do |format|
      if @comment.save
        make_child_comment
        format.html  { redirect_back fallback_location: book_review_comments_path }
      else
        format.html  { render 'new' }
      end
    end
  end

  def create_comment
    comment = Comment.new(params_comment)
    if comment.save
      review = Review.find_by(id: params[:comment][:commentable_id])
      Notification.create(subscriber_id: review.user.id, notifi_id: params[:comment][:user_id], message: 'comment', book_id: params[:comment][:book_id])
      redirect_to book_path(params[:comment][:book_id])
    end
  end

  def params_comment
    params.require(:comment).permit(:commentable_id, :user_id, :body, :commentable_type)
  end
  private

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type, :comment_id)
  end

  def commentable_type
    comment_params[:commentable_type]
  end

  def commentable_id
    comment_params[:commentable_id]
  end

  def comment_id
    comment_params[:comment_id]
  end

  def body
    comment_params[:body]
  end

  def make_child_comment
    return "" if comment_id.blank?

    parent_comment = Comment.find comment_id
    @comment.move_to_child_of(parent_comment)
  end


end
