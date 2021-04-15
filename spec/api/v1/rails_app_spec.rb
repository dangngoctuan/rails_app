require 'rails_helper'

describe "get profiles", type: :request do
  let!(:user) { create(:user, fb_id: SecureRandom.hex(9), name: Faker::Lorem.sentence) }
  before do
    @access_token = SecureRandom.hex(64)
    authentication_token = user.authentication_tokens.create
    authentication_token.digest!(@access_token)
  end
  it 'returns profiles' do
    get '/api/v1/profiles', params: { access_token: @access_token }

    results = JSON.parse(response.body)
    expect(results['name']).to eq(user.name)
    expect(results['image_url']).to eq(user.image_url)
  end
end

describe 'user login' do
  context 'with user existed' do
    let!(:user) { create(:user, fb_id: SecureRandom.hex(9), name: Faker::Lorem.sentence) }
    it do
      access_token = SecureRandom.hex(64)
      post '/api/v1/login', params: { access_token: access_token, data: { id: user.fb_id } }

      results = JSON.parse(response.body)
      expect(results['name']).to eq(user.name)
      expect(results['image_url']).to eq(user.image_url)
      expect(user.authentication_tokens.present?).to eq(true)
    end
  end

  context 'with user not existed' do
    it do
      access_token = SecureRandom.hex(64)
      expect {
        post '/api/v1/login', params: { access_token: access_token, data: { id: SecureRandom.hex(9), name: Faker::Lorem.sentence } }
      }.to change(User, :count).by(1)
    end
  end
end

describe 'user logout' do
  let!(:user) { create(:user, fb_id: SecureRandom.hex(9), name: Faker::Lorem.sentence) }
  it do
    access_token = SecureRandom.hex(64)
    authentication_token = user.authentication_tokens.create
    authentication_token.digest!(access_token)

    delete '/api/v1/logout', params: { access_token: access_token }
    user.authentication_tokens.reload
    expect(user.authentication_tokens.blank?).to eq(true)
    expect(JSON.parse(response.body)['status']).to eq('success')
  end
end
