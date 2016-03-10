class AddingForeignKeyConstraintToTables < ActiveRecord::Migration
  def up
    add_foreign_key :conversations, :users, column: :sender_id
    add_foreign_key :conversations, :users, column: :recipient_id
    add_foreign_key :industry_products, :products
    add_foreign_key :industry_products, :industries
    add_foreign_key :messages, :conversations
    add_foreign_key :messages, :users
    add_foreign_key :notifications, :users, column: :sender_id
    add_foreign_key :notifications, :users, column: :recipient_id
    add_foreign_key :post_comments, :posts
    add_foreign_key :post_comments, :users
    add_foreign_key :posts, :users
    add_foreign_key :products, :users
    add_foreign_key :profiles, :users
    add_foreign_key :tasks, :users, column: :executor_id
    add_foreign_key :tasks, :users, column: :assigner_id
  end

  def down
    remove_foreign_key :conversations, column: :sender_id
    remove_foreign_key :conversations, column: :recipient_id
    remove_foreign_key :industry_products, :products
    remove_foreign_key :industry_products, :industries
    remove_foreign_key :messages, :conversations
    remove_foreign_key :messages, :users
    remove_foreign_key :notifications, column: :sender_id
    remove_foreign_key :notifications, column: :recipient_id
    remove_foreign_key :post_comments, :posts
    remove_foreign_key :post_comments, :users
    remove_foreign_key :posts, :users
    remove_foreign_key :products, :users
    remove_foreign_key :profiles, :users
    remove_foreign_key :tasks, column: :executor_id
    remove_foreign_key :tasks, column: :assigner_id
  end
end
