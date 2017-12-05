class BooksController < ApplicationController
  before_action :find_book, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit]
  before_action :get_categories, only: [:new, :edit, :create, :update]
  skip_before_action :check_params_search, only: :index

  def index
    if params[:search]
      @books=Book.search(params[:search]).order("created_at DESC")
    else
      if params[:category].blank?
        @random_book = Book.order('RANDOM()').first(5)
        @categories = Category.all.paginate(page: params[:page], per_page: 5).order("created_at DESC")
      else
        @category_id = Category.find_by(name: params[:category])
        @books = @category_id.books.paginate(page: params[:page],per_page: 4)
        @category_name = @category_id.name
      end
    end
  end

  def new
    @book = current_user.books.build
  end

  def show
    @reviews = @book.reviews.order(created_at: :desc).paginate(page: params[:page], per_page: 3)
    if user_signed_in?
      @flag = Review.where(:book_id => @book, :user_id => current_user.id)
    end
    if @book.reviews.blank?
      @average_review = 0
    else
      @reviews = @book.reviews.order(created_at: :desc).paginate(page: params[:page], per_page: 3)
      @average_review = @book.reviews.average(:rating)
    end
  end

  def edit
    @bookcategories = @book.categories
  end

  def update
    @book.categories.destroy_all
    add_categories
    if @book.update(book_params)
      redirect_to @book
    else
      render 'edit'
    end
  end

  def destroy
    @book.destroy
    redirect_to root_path
  end

  def create
    @book = current_user.books.build(book_params)
    add_categories
    if @book.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  private
  def book_params
    params.require(:book).permit(:title, :description, :author, :category_id, :book_img)
  end

  def find_book
    @book = Book.find(params[:id])
  end

  def add_categories()
    if params[:book][:category_id]
      params[:book][:category_id].each {|category|
          @book.categories << Category.find_by(id: category)
      }
    end
  end

  def get_categories
    @categories = Category.all
  end
end
