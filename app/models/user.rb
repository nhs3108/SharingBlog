class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  mount_uploader :picture, PictureUploader
  EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: {minimum: 6, maximum: 30}
  validates :email, presence: true, length: {maximum: 30}, format: {with: EMAIL_FORMAT},
                                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: {minimum: 6, maximum: 255}, allow_nil: true
  validates :picture, presence: true, allow_nil: true
  validate :picture_size
  
  has_many :entries, dependent: :destroy
  has_many :active_relationships,  class_name:  "Relationship",
                                 foreign_key: "follower_id",
                                 dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                 foreign_key: "followed_id",
                                 dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :comments
  before_save :downcase_email
  before_create :create_activation_digest

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def remember
      self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_token, nil)
  end

  def follow other_user
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow other_user
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def feed
    Entry.where("user_id IN (:following_ids) OR user_id = :user_id",following_ids: following_ids, user_id: id)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def password_reset_expired?
    reset_at < 2.hours.ago
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_at, Time.zone.now)
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def picture_size
    if picture.size > 1.megabytes
      errors.add(:picture, "Shoud be less than 1 MB")
    end
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
