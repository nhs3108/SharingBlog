class Entry < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  default_scope -> {order(created_at: :desc)}
  validates :title, presence: true, length: {minimum: 1, maximum: 100}
  validates :body, presence: true

end
