require 'rails_helper'

describe CompanyFinalCustomer do
  it 'should validate uniqueness of association' do
    company = Company.create!(email_domain: 'codeplay.com.br',
                              cnpj: '00000000000000',
                              name: 'Codeplay Cursos SA',
                              billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                              billing_email: 'financas@codeplay.com.br')
    final_customer = FinalCustomer.create!(name: 'Fulano Sicrano',
                                           cpf: '54321012345')
    CompanyFinalCustomer.create!(company: company,
                                 final_customer: final_customer)

    should validate_uniqueness_of(:final_customer_id)
      .scoped_to(:company_id).with_message('já está em uso')
  end
end
