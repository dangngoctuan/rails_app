module V1
  module RailsHelper
    extend ActiveSupport::Concern
    included do
      version 'v1'
      format :json
      helpers do
        def digest_access_token(user, access_token)
          authentication_token = user.authentication_tokens.create
          authentication_token.digest!(access_token)
        end
      end
    end
  end
end
