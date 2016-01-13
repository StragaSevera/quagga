require 'rails_helper'

RSpec.describe User, type: :model do
  let (:user) { build(:user) }

  context "with validations" do
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_least(2).is_at_most 30 }

    it { should validate_presence_of :email }
    it { should validate_length_of(:email).is_at_least(2).is_at_most 200 }

    it { should validate_presence_of :password }  
    it { should validate_length_of(:password).is_at_least(4).is_at_most 200 }

    it { should have_many(:questions) } 
    it { should have_many(:answers) } 
    it { should have_many(:comments) } 
    it { should have_many(:authorizations) } 
  end

  describe ".find_for_oauth" do
    let!(:user) { create(:user) }

    context 'having authorization' do
      let (:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'not having authorization' do
      context 'when user already exists' do
        let (:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do
          expect {User.find_for_oauth(auth)}.not_to change(User, :count)
        end

        it 'creates authorization for user' do
          expect {User.find_for_oauth(auth)}.to change(user.authorizations, :count).by 1
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end

      context 'when user does not exist' do
        let (:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: "new@user.com", name: "Новый Пользователь" }) }

        # Странная микропроблема (решилась сама собой, оставляю на всякий случай в качестве заметок, в следующем занятии уберу, если не вернется).
        # Если я запускаю сначала oauth_signup_spec,
        # а затем эту спеку, то следующий тест выдает ошибку:

        #    Failure/Error: User.create!(email: email, name: name, password: password, password_confirmation: password)
        # ActiveRecord::RecordNotUnique:
        #   PG::UniqueViolation: ОШИБКА:  повторяющееся значение ключа нарушает ограничение уникальности "users_pkey"
        #   DETAIL:  Ключ "(id)=(1)" уже существует.
        #   : INSERT INTO "users" ("email", "name", "encrypted_password", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5) RETURNING "id"

        # Если запустить user_spec два раза подряд, то второй раз она пройдет как ни в чем не бывало.
        # Посмотрел ручками - oauth_signup_spec за собой базу "чистит", БД тестовая пустая.
        # Также эту проблему "лечит" spring stop.
        # Не имею ни малейшего понятия, откуда оно взялось и как пофиксить о_О

        it 'creates new user' do
          expect {User.find_for_oauth(auth)}.to change(User, :count).by 1
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a User
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'fills user name' do
          user = User.find_for_oauth(auth)
          expect(user.name).to eq auth.info.name
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).not_to be_empty
        end

        it 'creates authorization for user with correct provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end