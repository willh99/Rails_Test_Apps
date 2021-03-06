class User < ApplicationRecord
    # Database Associations
    has_many :microposts, dependent: :destroy
    has_many :active_relationships, class_name:  "Relationship",
                                    foreign_key: "follower_id",
                                    dependent:   :destroy
    has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key:  "followed_id",
                                   dependent:    :destroy
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower
    
    # Attribute accessors and before filters
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save   :downcase_email
    before_create :create_activation_digest
    
    # Validations
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: {case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil:true
    
    # Returns the hash digest of the given string
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
    
    # Returns a random token
    def User.new_token
        SecureRandom.urlsafe_base64
    end
    
    # Remembers a user in the database for use in persistent sessions
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end
    
    # Returns true if the given token matches the digest.
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end
    
    # Forget a user's remember_digest
    def forget
        update_attribute(:remember_digest, nil)
    end
    
    # Activate a user by setting activated to true
    def activate
        update_columns(activated: true, activated_at: Time.zone.now)
    end
    
    # Send and activation email to the user's email
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end
    
    # Create a reset digest using a new token (used for password reset)
    def create_reset_digest
        self.reset_token = User.new_token
        update_columns(reset_digest: User.digest(reset_token),
                       reset_sent_at: Time.zone.now)
    end
    
    # Send password reset email to the user's email
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end
    
    # Check if the password reset was created more than 2 hours ago
    def password_reset_expired?
        reset_sent_at < 2.hours.ago 
    end
    
    # Returns a users feed comprising of their own posts and those of
    # other users whom they follow
    def feed
        following_ids = "SELECT followed_id FROM relationships
                         WHERE  follower_id = :user_id"
        Micropost.where("user_id IN (#{following_ids})
                         OR user_id = :user_id", user_id: id)
    end
    
    # Follows a user by appending to following
    def follow(other_user)
        following << other_user
    end
    
    # Unfollows a user by removing from following
    def unfollow(other_user)
        following.delete(other_user)
    end
    
    # Returns true if the current user is following the other user.
    def following?(other_user)
        following.include?(other_user)
    end
    
    private
    
        # Converts and email to all lower-case
        def downcase_email
            self.email = email.downcase
        end
            
        # Creates and assigns the activation token and digest
        def create_activation_digest
            self.activation_token  = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
end
