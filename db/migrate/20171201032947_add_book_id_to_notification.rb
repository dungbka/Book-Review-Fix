class AddBookIdToNotification < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :book_id, :integer
  end
end
