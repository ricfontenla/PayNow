require 'rails_helper'

describe 'user authentication' do
  context 'for company' do
    it 'cannot access create if already has a company' do
      user_customer_login
      post user_companies_path

      expect(response).to redirect_to(root_path)
    end

    it 'cannot access update a company if is not a customer_admin' do
      user_customer_login
      put user_company_path(1)

      expect(response).to redirect_to(root_path)
    end

    it 'cannot access update a company if is not a customer_admin' do
      user_customer_login
      put generate_token_user_company_path(1)

      expect(response).to redirect_to(root_path)
    end
  end
end
