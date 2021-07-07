require 'rails_helper'

describe 'visitor tries to access admin area' do
  context 'of payment methods' do
    it 'and cannot view index' do
      visit admin_payment_methods_path

      expect(current_path).to eq(new_admin_session_path)
    end

    it 'and cannot view show' do
      visit admin_payment_method_path(1)

      expect(current_path).to eq(new_admin_session_path)
    end

    it 'and cannot view new' do
      visit new_admin_payment_method_path

      expect(current_path).to eq(new_admin_session_path)
    end

    it 'and cannot view edit' do
      visit edit_admin_payment_method_path(1)

      expect(current_path).to eq(new_admin_session_path)
    end
  end

  context 'of companies' do
    it 'and cannot view index' do
      visit admin_companies_path

      expect(current_path).to eq(new_admin_session_path)
    end

    it 'and cannot view show' do
      visit admin_company_path(1)

      expect(current_path).to eq(new_admin_session_path)
    end

    it 'and cannot view edit' do
      visit edit_admin_company_path(1)

      expect(current_path).to eq(new_admin_session_path)
    end
  end

  context 'of orders' do
    it 'and cannot view index' do
      visit admin_company_orders_path(1)

      expect(current_path).to eq(new_admin_session_path)
    end

    it 'and cannot view show' do
      visit admin_company_order_path(1, 1)

      expect(current_path).to eq(new_admin_session_path)
    end

    it 'and cannot view edit' do
      visit edit_admin_company_order_path(1, 1)

      expect(current_path).to eq(new_admin_session_path)
    end
  end
end
