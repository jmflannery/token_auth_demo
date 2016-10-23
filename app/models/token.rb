class Token < ApplicationRecord
  belongs_to :user

  def generate_key
    begin
      self.key = Devise.friendly_token(64)
    end while self.class.exists?(key: self.key)
  end
end
