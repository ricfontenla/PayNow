require 'rails_helper'

describe 'user tries to mess with company show and registration' do
  context ' and already associated with a company, tries to register another' do
    it 'and fails' do
      user_customer_admin_login
      visit new_user_company_path

      expect(current_path).to eq(root_path)
    end
  end

  context 'and without a company tries to access details' do
    it 'and fails' do
      user_first_login
      visit user_company_path(1)

      expect(current_path).to eq(root_path)
    end
  end
end