FactoryBot.define do
  factory :company do
    email_domain { 'codeplay.com.br' }
    cnpj { '00000000000000' }
    name { 'Codeplay Cursos SA' }
    sequence(:billing_adress) { |n| "Rua banana, numero #{n} - Bairro Laranja, 00000-000" }
    sequence(:billing_email) { |n| "'financas#{n}@codeplay.com.br'" }
  end
end