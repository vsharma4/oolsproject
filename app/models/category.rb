class Category < ActiveRecord::Base
  attr_accessible :category
  has_many :posts
  validates :category, :presence => true
end
