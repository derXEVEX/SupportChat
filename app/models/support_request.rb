
class SupportRequest < ApplicationRecord
  has_paper_trail
  belongs_to :user
  belongs_to :category
  has_many :messages, dependent: :destroy

  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: ["offen", "in Bearbeitung", "geschlossen"] }

  def closed?
    status == "geschlossen"
  end
end
