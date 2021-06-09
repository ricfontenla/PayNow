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
end