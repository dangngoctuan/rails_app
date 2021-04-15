class User < ApplicationRecord
  has_many :authentication_tokens
end
