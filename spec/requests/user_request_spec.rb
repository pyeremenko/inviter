require 'rails_helper'

RSpec.describe 'users', type: :request do
  describe 'POST /login' do
    let(:user) { create :user }
    let(:password) { user.password }

    before { post '/login', params: { email: user.email, password: password } }

    it 'returns a success response' do
      expect(response).to be_successful

      expect(json_body).to include 'auth_token' => a_string_matching(/.+\..+\..+/)
      expect(json_body).to include 'user' => a_hash_including(
        'email' => user.email,
        'name' => user.name
      )
    end

    context 'when the password is not valid' do
      let(:password) { 'some wrong password' }

      it 'returns an error response' do
        expect(response).not_to be_successful

        expect(json_body).not_to include 'auth_token' => a_string_matching(/.+\..+\..+/)
        expect(json_body).to have_key 'error'
        expect(json_body).to include 'details' => a_hash_including(
          'user_authentication' => a_string_matching(/.+/)
        )
      end
    end
  end

  describe 'POST /signup' do
    let(:user_attrs) { { email: 'test@test.com', password: 'passwd', name: 'john' } }
    let(:user_payload) { user_attrs }

    before { post '/signup', params: user_payload }

    it 'returns a success response' do
      expect(response).to be_successful

      expect(json_body).to include 'auth_token' => a_string_matching(/.+\..+\..+/)
      expect(json_body).to include 'user' => a_hash_including(
        'email' => user_payload[:email],
        'name' => user_payload[:name]
      )
    end

    context 'when email is wrong' do
      let(:user_payload) { user_attrs.merge({ email: 'bad.email.com' }) }

      it 'returns an error' do
        expect(response).not_to be_successful

        expect(json_body).not_to include 'auth_token' => a_string_matching(/.+\..+\..+/)
        expect(json_body).to have_key 'error'
        expect(json_body).to include 'details' => a_hash_including(
          'email' => a_collection_including(a_string_matching(/invalid/))
        )
      end
    end

    context 'when has an invite code' do
      let(:invite) { create :invite }
      let(:user_payload) { user_attrs.merge({ code: invite.code }) }

      it 'returns a user with 10 credits' do
        expect(json_body).to include 'user' => a_hash_including('credits' => 10)
      end

      context 'which is invalid' do
        let(:user_payload) { user_attrs.merge({ code: 'bad.invite.code' }) }

        it 'returns a user with no credits' do
          expect(json_body).to include 'user' => a_hash_including('credits' => 0)
        end
      end
    end

    context 'when 5th invitee signs up' do
      let(:invite) { create :invite, usages: 4 }
      let(:inviter) { invite.user }
      let(:user_payload) { user_attrs.merge({ code: invite.code }) }

      it 'increases credits of inviter' do
        expect(inviter.credits).to eq(0)

        expect(inviter.reload.credits).to eq(10)
        expect(invite.reload.usages).to eq(5)
        expect(invite.reload.bonus_applied).to be_truthy
      end
    end

    context 'when 6th invitee signs up' do
      let(:user) { create :user, credits: 10 }
      let(:invite) { create :invite, usages: 5, bonus_applied: true, user: user }
      let(:inviter) { invite.user }
      let(:user_payload) { user_attrs.merge({ code: invite.code }) }

      it 'increases credits of inviter' do
        expect(inviter.credits).to eq(10)

        expect(inviter.reload.credits).to eq(10)
        expect(invite.reload.usages).to eq(6)
      end
    end
  end

  describe 'GET /info' do
    let(:user) { create :user }
    let(:token) { AuthenticateUser.call(user.email, user.password).result }

    before { get '/info', params: {}, headers: { 'Authorization' => token } }

    it 'returns user details' do
      expect(response).to be_successful
      expect(json_body).to include 'message' => 'Ok'
      expect(json_body).to include 'user' => a_hash_including(
        'email' => user.email,
        'name' => user.name,
        'credits' => user.credits
      )
    end
  end
end
