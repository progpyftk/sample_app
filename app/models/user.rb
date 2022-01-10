class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token # nao pode ficar na DB - eh armazenado nos cookies

  before_save :downcase_email
  before_create :create_activation_digest
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token. eh o que sera armazenado nos cookies de forma permanente
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # gera o remember token e o atualiza na DB na forma de digest, sendo o remember_digest
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def create_activation_digest
    # notar que activation_token trata-se de um atributo virtual, pois nao esta na db
    self.activation_token = User.new_token
    # dentro do model o "self" do lado direito é opcional, logo podemos fazer activation_token
    puts "Criando o activation_digest"
    self.activation_digest = User.digest(self.activation_token)
  end

  # dentro do model o "self" do lado direito é opcional, por isso podemos fazer email.downcase
  def downcase_email
    self.email = email.downcase
  end
end
