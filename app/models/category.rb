class Category < ApplicationRecord
  has_many :support_requests
  validates :name, presence: true, uniqueness: true
end