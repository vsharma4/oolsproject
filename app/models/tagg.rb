class Tagg < ActiveRecord::Base
  belongs_to :post
  attr_accessible :name

  validates_length_of :name, :within => 1..20
  validates_format_of :name, :with => /^[a-zA-Z0-9_]*$/, :message => "Please enter a single word tag"
end
