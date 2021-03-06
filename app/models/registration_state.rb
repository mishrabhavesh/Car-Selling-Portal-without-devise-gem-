class RegistrationState < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
    before_save :upcase_fields, if: :name?
    has_many :sellers
    
    private
    
    def upcase_fields
      self.name.upcase!
    end
  end