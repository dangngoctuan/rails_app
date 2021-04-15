class AuthenticationToken < ApplicationRecord
  belongs_to :user, optional: true

  def digest!(token)
    self.hashed_id = self.class.digest token
    save!
  end

  def self.authenticate(token)
    find_by hashed_id: digest(token)
  end

  def self.digest(token)
    Digest::SHA1.hexdigest token.to_s
  end
end
