module V1
  module Authentication
    extend ActiveSupport::Concern
    included do
      version 'v1'
      format :json
      helpers do
        def current_user(access_token)
          @authentication_token = AuthenticationToken.authenticate(access_token)
          return nil if @authentication_token.blank?
          @user = @authentication_token.user
        end

        def authenticate!(access_token)
          errors = { error: 'authenticate error', error_code: 401 }
          error!(errors, 401) unless current_user(access_token)
        end
      end
    end
  end
end
