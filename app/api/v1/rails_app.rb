require 'json'
module V1
  class RailsApp < Grape::API
    include V1::Authentication
    include V1::RailsHelper

    namespace do
      desc 'get info'
      get :profiles do
        authenticate!(params['access_token'])
        begin
          data = {
            name: @user.name,
            image_url: @user.image_url
          }
          present data
        rescue  StandardError => e
          error!(e.message, 500)
        end
      end

      desc 'login'
      post :login do
        begin
          user = User.find_by_fb_id(params.dig('data', 'id'))
          if user.present? && params['access_token'].present?
            digest_access_token(user, params['access_token'])
            data = {
              name: user.name,
              image_url: user.image_url
            }
          else
            user = User.create!({
              fb_id: params.dig('data', 'id'),
              name: params.dig('data', 'name'),
              image_url: params.dig('data', 'picture', 'data', 'url')
            })
            digest_access_token(user, params['access_token'])
            data = {
              name: user.name,
              image_url: user.image_url
            }
          end
          present data
        rescue  StandardError => e
          error!(e.message, 500)
        end
      end

      desc 'logout'
      delete :logout do
        authenticate!(params['access_token'])
        begin
          @authentication_token.delete
          data = { status: 'success' }
          present data
        rescue  StandardError => e
          error!(e.message, 500)
        end
      end
    end

  end
end
