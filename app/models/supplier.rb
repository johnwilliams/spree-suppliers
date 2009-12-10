class Supplier < ActiveRecord::Base
  belongs_to :state
  has_many :products
end
