class ReviewsController < ApplicationController
  before_action :find_book, except: [:index]
  before_action :find_review, only: [:edit, :update, :destroy, :show]
  before_action :authenticate_user!, only: [:new, :edit]

  def index
    @reviews = Review.most_recent
  end

  def new
    @review = Review.new
  end

  def show
    @reviews = Review.where(:book_id => @book)
    @new_comment = Comment.build_from(@review, current_user.id, "")
    @all_comments = @review.comment_threads
  end

  def create
    @review = Review.new(review_params)
    @review.book_id = @book.id
    @review.user_id = current_user.id
    if @review.save
      @followers = @current_user.votes_for.up.by_type("User").voters
      if @followers.any?
        @followers.each do |subscriber|
          Notification.create(subscriber_id: subscriber.id, notifi_id: current_user.id, message: 'review', book_id: @review.book.id)
        end
      end
      redirect_to book_path(@book)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @review = Review.find(params[:id])

    if @review.update(review_params)
      redirect_to book_path(@book)
    else
      render 'edit'
    end
  end

  def destroy
    @review.destroy
    redirect_to book_path(@book)
  end

  private
    def review_params
      params.require(:review).permit(:rating, :comment)
    end

    def find_book
      @book = Book.find(params[:book_id])
    end

    def find_review
      @review = Review.find(params[:id])
    end

end
