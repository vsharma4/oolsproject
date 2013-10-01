class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :comments, :dependent => :destroy
  has_many :post_votes, :dependent => :destroy
  has_many :taggs

  attr_accessible :description, :title, :category, :category_id

  validates :title, :presence => true
  validates :description, :presence => true
  validates :user, :presence => true
  validates :category, :presence => true

  def self.is_owner?(post, user)
    some_post = Post.where("id = ? and user_id = ?",post, user)
    if some_post.empty?
      false
    else
      true
    end
  end

  def self.search_by_user(search)
    search_condition = "%" + search + "%"
    find_user = User.where("email like ? OR name like ?",search_condition, search_condition)
    result = find(:all, :conditions => ['1=2'])
    for i in find_user do
      result = result + find(:all, :conditions => ['user_id = ?', i.id])
    end
    return result
  end

  def self.search_by_category(search)
    search_condition = "%" + search + "%"
    find_category = Category.where("category like ?",search_condition)
    result = find(:all, :conditions => ['1=2'])
    for i in find_category do
      result = result + find(:all, :conditions => ['category_id = ?', i.id])
    end
    return result
  end

  def self.search_by_content(search)
    search_condition = "%" + search + "%"
    find(:all, :conditions => ['title LIKE ? OR description LIKE ?', search_condition,search_condition])
  end


  def self.search_by_tag(search)
    search_condition = "%" + search + "%"
    find_tag = Tagg.where("name LIKE ?",search_condition)
    result = find(:all, :conditions => ['1=2'])
    for i in find_tag do
      result = result+find(:all, :conditions => ['id = ?', i.post_id])
    end
    return result
  end
end
