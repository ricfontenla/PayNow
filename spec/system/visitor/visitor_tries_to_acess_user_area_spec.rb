require 'rails_helper'

describe 'visitor tries to access user area' do
  context 'of companies' do
    it 'and cannot view new' do
      visit new_user_company_path

      expect(current_path).to eq(new_user_session_path)
    end

    it 'and cannot view show' do
      visit user_company_path(1)

      expect(current_path).to eq(new_user_session_path)
    end

    it 'and cannot view edit' do
      visit edit_user_company_path(1)

      expect(current_path).to eq(new_user_session_path)
    end
  end

  context 'of payment methods' do
    it 'and cannot view index' do
      visit user_company_payment_methods_path(1)

      expect(current_path).to eq(new_user_session_path)
    end

    it 'and cannot view show' do
      visit user_company_payment_method_path(1, 1)

      expect(current_path).to eq(new_user_session_path)
    end
  end
end