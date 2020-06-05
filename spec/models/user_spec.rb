# frozen_string_literal: true

require('rails_helper')

describe User, type: :model do
  subject do
    described_class.new(
      username: 'username',
      email: 'user@email.com',
      password: 'password'
    )
  end

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    describe 'username' do
      context 'when username is nil' do
        it 'is NOT valid' do
          subject.username = nil
          expect(subject).to_not be_valid
        end
      end

      context 'when username is less than 3 characters' do
        it 'is NOT valid' do
          subject.username = 'us'
          expect(subject).to_not be_valid
        end
      end

      context 'when username is 3 characters or more' do
        it 'is valid' do
          subject.username = 'Tod'
          expect(subject).to be_valid
        end
      end
    end

    describe 'email' do
      context 'when email is nil' do
        it 'is NOT valid' do
          subject.email = nil
          expect(subject).to_not be_valid
        end
      end

      context 'when email is not in the correct format' do
        it 'is NOT valid' do
          subject.email = 'email'
          expect(subject).to_not be_valid
        end
      end

      context 'when email is in the correct format' do
        it 'is valid' do
          subject.email = 'user@email.com'
          expect(subject).to be_valid
        end
      end

      context 'when email is not unique' do
        before { described_class.create!(username: 'oldUser', email: 'user@email.com', password: 'password') }

        it 'is NOT valid' do
          expect(subject).to_not be_valid
        end
      end
    end

    describe 'password' do
      context 'when password is nil' do
        it 'is NOT valid' do
          subject.password = nil
          expect(subject).to_not be_valid
        end
      end

      context 'when password is less than 6 characters' do
        it 'is NOT valid' do
          subject.password = 'pass'
          expect(subject).to_not be_valid
        end
      end

      context 'when password is 6 characters or more' do
        it 'is valid' do
          subject.password = 'password'
          expect(subject).to be_valid
        end
      end
    end
  end
end
