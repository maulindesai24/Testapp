class User < ApplicationRecord
    has_secure_password

    # Define is_admin as a virtual (non-persisted) attribute
    # This prevents ActiveRecord from trying to insert it into the database
    attribute :is_admin, :boolean, default: false
    
    # Override to use role-based admin check instead of database column
    def is_admin
      admin?
    end
    
    # Override setter to prevent it from being saved
    def is_admin=(value)
      # Silently ignore - we use role-based admin instead
      @is_admin = value
    end

    # Associations for role table
    belongs_to :role

    # Callbacks
    before_validation :set_default_role, on: :create
    before_save :remove_is_admin_from_changes

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

    validates :role, presence: true

    def generate_password_reset
        self.reset_password_token = SecureRandom.hex(10)
        self.reset_password_sent_at = Time.current
        save(validate: false)
    end

    def password_reset_expired?
        reset_password_sent_at < 2.hours.ago
    end

    def name
        "#{firstname} #{lastname}".strip
    end
    
    def admin?
        role&.admin?
    end

    private

    def set_default_role
      if role_id.blank?
        default_role = Role.find_by(name: 'user')
        self.role_id = default_role.id if default_role
      end
    end

    def remove_is_admin_from_changes
      # Remove is_admin from changes to prevent ActiveRecord from trying to save it
      if changed_attributes.has_key?('is_admin')
        changed_attributes.delete('is_admin')
      end
      if changed_attributes.has_key?(:is_admin)
        changed_attributes.delete(:is_admin)
      end
    end
end
