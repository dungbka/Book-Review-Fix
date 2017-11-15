class Book < ApplicationRecord
  belongs_to :user
  has_many :book_categories
  has_many :categories, :through => :book_categories, :dependent => :destroy
  has_many :reviews

  has_attached_file :book_img, styles: { book_index: "250x250>", book_show: "325x475>" }, default_url: ':placeholder'
  validates_attachment_content_type :book_img, content_type: /\Aimage\/.*\z/
  validates :title, presence: true
  validates :author, presence: true
  validates :categories, presence: true

  def self.search key_word
    word = trim key_word, " ."
    where("title LIKE ?", "%#{word}%")
    where("author LIKE ?", "%#{word}%")
    where("description LIKE ?", "%#{word}%")
  end

  def reviewer_followed_by user
    return nil unless review = reviews.priority(user).most_recent.first
    review.user_id
  end


  def self.trim string, chars
    chars = Regexp.escape chars
    string.gsub /\A[#{chars}]+|[#{chars}]+\z/, ""
  end

  def total_rate
    unless Review.where(book_id: self.id).count==0
      Review.where(book_id: self.id).count
    else
      0
    end


  end

  def rate_one
    unless total_rate==0
      Review.where(book_id: self.id, rating: '1').count
    else
      0
    end
  end

  def rate_two
    unless total_rate==0
      Review.where(book_id: self.id, rating: '2').count
    else
      0
    end
  end
  def rate_three
    unless total_rate==0
      Review.where(book_id: self.id, rating: '3').count
    else
      0
    end
  end
  def rate_four
    unless total_rate==0
      Review.where(book_id: self.id, rating: '4').count
    else
      0
    end
  end
  def rate_five
    unless total_rate==0
      Review.where(book_id: self.id, rating: '5').count
    else
      0
    end
  end

  def rate_one_per
    unless total_rate==0
      (self.rate_one/self.total_rate.to_f)*80.to_i
    else
      0
    end
  end

  def rate_two_per
    unless total_rate==0
      (self.rate_two/self.total_rate.to_f*80).to_i
    else
      0
    end
  end

  def rate_three_per
    unless total_rate==0
      (self.rate_three/self.total_rate.to_f*80).to_i
    else
      0
    end
  end

  def rate_four_per
    unless total_rate==0
      (self.rate_four/self.total_rate.to_f*80).to_i
    end
  end

  def rate_five_per
    unless total_rate==0
      (self.rate_five/self.total_rate.to_f*80).to_i
    end
  end

end
