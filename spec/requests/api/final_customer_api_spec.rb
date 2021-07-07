require 'rails_helper'

describe 'FinalCustomers API' do
  context 'POST api/v1/final_customers' do
    it 'and should create a new customer and associate with company' do
      Company.create!(email_domain: 'codeplay.com.br',
                      cnpj: '00000000000000',
                      name: 'Codeplay SA',
                      billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                      billing_email: 'financas@codeplay.com.br')

      post '/api/v1/final_customers', params:
      {
        final_customer:
        {
          name: 'Fulano Sicrano',
          cpf: '98765432101'
        },
        company_token: Company.last.token.to_s
      }

      expect(response.content_type).to include('application/json')
      expect(response).to have_http_status(201)
      expect(parsed_body['name']).to eq('Fulano Sicrano')
      expect(parsed_body['cpf']).to eq('98765432101')
      expect(parsed_body['token']).to eq(FinalCustomer.last.token)
      expect(FinalCustomer.last.companies).to include(Company.last)
    end

    it 'and company not found' do
      post '/api/v1/final_customers', params: {}

      expect(response).to have_http_status(412)
      expect(response.body).to include('Token Inválido')
    end

    it 'and cpf should be a number' do
      Company.create!(email_domain: 'codeplay.com.br',
                      cnpj: '00000000000000',
                      name: 'Codeplay SA',
                      billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                      billing_email: 'financas@codeplay.com.br')

      post '/api/v1/final_customers', params:
      {
        final_customer:
        {
          name: 'Fulano Sicrano',
          cpf: 'qwertyuiopl'
        },
        company_token: Company.last.token.to_s
      }

      expect(response).to have_http_status(412)
      expect(response.body).to include('Parâmetros Inválidos')
    end

    it 'and params cannot be blank' do
      Company.create!(email_domain: 'codeplay.com.br',
                      cnpj: '00000000000000',
                      name: 'Codeplay SA',
                      billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                      billing_email: 'financas@codeplay.com.br')

      post '/api/v1/final_customers', params:
      {
        final_customer:
        {
          name: '',
          cpf: ''
        },
        company_token: Company.last.token.to_s
      }

      expect(response).to have_http_status(412)
      expect(response.body).to include('Parâmetros Inválidos')
    end

    it 'and cpf should have 11 characters' do
      Company.create!(email_domain: 'codeplay.com.br',
                      cnpj: '00000000000000',
                      name: 'Codeplay SA',
                      billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                      billing_email: 'financas@codeplay.com.br')

      post '/api/v1/final_customers', params:
      {
        final_customer:
        {
          name: 'Fulano Sicrano',
          cpf: '9876543210123456789'
        },
        company_token: Company.last.token.to_s
      }

      expect(response).to have_http_status(412)
      expect(response.body).to include('Parâmetros Inválidos')
    end

    it 'and should associate a existing final customer with a company' do
      company = Company.create!(email_domain: 'codeplay.com.br',
                                cnpj: '00000000000000',
                                name: 'Codeplay Cursos SA',
                                billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                                billing_email: 'financas@codeplay.com.br')
      Company.create!(email_domain: 'cookbook.com.br',
                      cnpj: '99999999999999',
                      name: 'Cookbook LTDA',
                      billing_adress: 'Rua Cereja, numero 99 - Bairro Limão, 11111-111',
                      billing_email: 'financas@cookbook.com.br')
      final_customer = FinalCustomer.create!(name: 'Fulano Sicrano',
                                             cpf: '54321012345')
      CompanyFinalCustomer.create!(company: company,
                                   final_customer: final_customer)

      post '/api/v1/final_customers', params:
      {
        final_customer:
        {
          name: 'Fulano Sicrano',
          cpf: '54321012345'
        },
        company_token: Company.last.token.to_s
      }

      expect(response.content_type).to include('application/json')
      expect(response).to have_http_status(201)
      expect(parsed_body['name']).to eq('Fulano Sicrano')
      expect(parsed_body['cpf']).to eq('54321012345')
      expect(parsed_body['token']).to eq(FinalCustomer.last.token)
      expect(FinalCustomer.last.companies).to include(Company.last)
    end

    it 'and should not associate it twice' do
      company = Company.create!(email_domain: 'codeplay.com.br',
                                cnpj: '00000000000000',
                                name: 'Codeplay Cursos SA',
                                billing_adress: 'Rua banana, numero 00 - Bairro Laranja, 00000-000',
                                billing_email: 'financas@codeplay.com.br')
      final_customer = FinalCustomer.create!(name: 'Fulano Sicrano',
                                             cpf: '54321012345')
      CompanyFinalCustomer.create!(company: company,
                                   final_customer: final_customer)

      post '/api/v1/final_customers', params:
      {
        final_customer:
        {
          name: 'Fulano Sicrano',
          cpf: '54321012345'
        },
        company_token: Company.last.token.to_s
      }

      expect(response.content_type).to include('application/json')
      expect(response).to have_http_status(412)
      expect(response.body).to include('Parâmetros Inválidos')
    end
  end
end
