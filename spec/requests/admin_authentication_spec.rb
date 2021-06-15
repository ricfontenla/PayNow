require 'rails_helper'

describe 'admin authentication' do
  context 'for payment methods' do
    it 'cannot access create whithout login' do
      post admin_payment_methods_path

      expect(response).to redirect_to(new_admin_session_path)
    end

    it 'cannot access update whithout login' do
      put admin_payment_method_path(1)

      expect(response).to redirect_to(new_admin_session_path)
    end

    it 'cannot access destroy without login' do
      delete admin_payment_method_path(1)

      expect(response).to redirect_to(new_admin_session_path)
    end
  end

  context 'for companies' do
    it 'cannot access update without login' do
      put admin_company_path(1)

      expect(response).to redirect_to(new_admin_session_path)
    end

    it 'cannot access generate token without login' do
      put generate_token_admin_company_path(1)

      expect(response).to redirect_to(new_admin_session_path)
    end
  end

  context 'for orders' do
    it 'and cannot access update without login' do
      put admin_company_order_path(1, 1)
      
      expect(response).to redirect_to(new_admin_session_path)
    end
  end
end