require 'rails_helper'

describe 'user authentication' do
  context 'for company' do
    it 'cannot access create whithout login' do
      post user_companies_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'cannot access edit whithout login' do
      put user_company_path(1)

      expect(response).to redirect_to(new_user_session_path)
    end
    
    it 'cannot access generate_token whithout login' do
      put generate_token_user_company_path(1)

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'for boleto_account' do
    it 'cannot access create without login' do
      post user_company_payment_method_boleto_accounts_path(1, 1)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'cannot access update withou login' do
      put user_company_payment_method_boleto_account_path(1, 1, 1)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'cannot access destroy withou login' do
      delete user_company_payment_method_boleto_account_path(1, 1, 1)

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'for card_account' do
    it 'cannot access create without login' do
      post user_company_payment_method_card_accounts_path(1, 1)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'cannot access update withou login' do
      put user_company_payment_method_card_account_path(1, 1, 1)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'cannot access destroy withou login' do
      delete user_company_payment_method_card_account_path(1, 1, 1)

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'for pix_account' do
    it 'cannot access create without login' do
      post user_company_payment_method_pix_accounts_path(1, 1)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'cannot access update withou login' do
      put user_company_payment_method_pix_account_path(1, 1, 1)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'cannot access destroy withou login' do
      delete user_company_payment_method_pix_account_path(1, 1, 1)

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'for product'do
    it 'cannot access create without login' do
      post user_company_products_path(1)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'cannot access update without login' do
      put user_company_product_path(1, 1)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'cannot access destroy without login' do
      delete user_company_product_path(1, 1)

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end