class Role < ApplicationRecord
  has_many :users, dependent: :restrict_with_error

  validates :name, 
    presence: true, 
    uniqueness: { case_sensitive: false },
    length: { maximum: 255 }

  def admin?
    name.downcase == 'admin'
  end

  def display_name
    name.humanize
  end
end
