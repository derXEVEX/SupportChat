class Message < ApplicationRecord
  has_paper_trail
  belongs_to :user
  belongs_to :support_request

  validates :content, presence: true
end
