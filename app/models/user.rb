class User < ApplicationRecord
    has_secure_password

    validates :email,
        presence: true,
        uniqueness: { case_sensitive: false },
        format: { with: URI::MailTo::EMAIL_REGEXP },
        length: { maximum: 255 }

    validates :username,
        presence: true,
        uniqueness: { case_sensitive: false },
        length: { minimum: 3, maximum: 255 },
        format: { with: /\A[a-zA-Z0-9]+\z/ } #only contain letters, numbers, and underscores
    
    validates :firstname,
        presence: true,
        length: { maximum: 255 }
    
    validates :lastname,
        presence: true,
        length: { maximum: 255 }
    
    VALID_PASSWORD_REGEX = /\A
        (?=.{8,})           # minimum length 8 characters
        (?=.*\d)            # must contain at least 1 digit
        (?=.*[a-z])         # must contain at least 1 lowercase letter
        (?=.*[A-Z])         # must contain at least 1 uppercase letter
        (?=.*[[:^alnum:]])  # must contain at least 1 special character
    /x

    validates :password,
        presence: true,
        format: { with: VALID_PASSWORD_REGEX ,
        message: "must be 8+ characters, include upper & lower case letters, a number, and a special character" }

    def generate_password_reset
        self.reset_password_token = SecureRandom.hex(10)
        self.reset_password_sent_at = Time.current
        save(validate: false) #( ! = it will raise an error if the save fails)
    end

    def password_reset_expired?
        reset_password_sent_at < 2.hours.ago
    end

    def name
        "#{firstname} #{lastname}".strip
    end
    
    def admin?
        is_admin
    end
end
