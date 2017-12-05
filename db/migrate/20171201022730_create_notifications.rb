class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :subscriber_id
      t.integer :notifi_id
      t.boolean :status, default: false
      t.string :message

      t.timestamps
    end
  end
end
