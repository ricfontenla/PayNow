require 'rails_helper'

describe 'user tries to access' do
  context 'company' do
    it ' registration page and already have a company' do
      user_customer_login
      visit new_user_company_path

      expect(current_path).to eq(root_path)
    end

    it 'edit page, and is not the customer admin' do
      user_customer_login
      visit edit_user_company_path(1)

      expect(current_path).to eq(root_path)
    end
  end
end
