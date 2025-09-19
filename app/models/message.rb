class Message < ApplicationRecord
  belongs_to :user
  belongs_to :support_request

  validates :content, presence: true
end
