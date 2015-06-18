class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :entry
  validates :content, presence: true, length: {maximum:255}
  validates :user_id, presence: true
  validates :entry_id, presence: true
end
