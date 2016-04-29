class Contact < ActiveRecord::Base
  validates :name, presence: { message: "can't be blank"},
                   length: { maximum: 50, message: "can't be longer than 50 characters" }                 
  validates :email, presence: { message: "can't be blank"},
                    length: { maximum: 255, message: "can't be longer than 255 characters" },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "must be valid"  }
  validates :comment, presence: { message: "can't be blank"}, 
                      length: { maximum: 500, message: "can't be longer than 500 characters"}
end