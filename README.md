# README

## PROJETO PAYNOW - TREINADEV 06

### Sobre o projeto
Uma escola de programação, a CodePlay, decidiu lançar uma plataforma de cursos online de
programação. Você já está trabalhando nesse projeto e agora vamos começar uma nova etapa:
uma ferramenta de pagamentos capaz de configurar os meios de pagamentos e registrar as
cobranças referentes a cada venda de curso na CodePlay. O objetivo deste projeto é construir
o mínimo produto viável (MVP) dessa plataforma de pagamentos.
Na plataforma de pagamentos temos dois perfis de usuários: os administradores da plataforma
e os donos de negócios que querem vender seus produtos por meio da plataforma, como as
pessoas da CodePlay, por exemplo. Os administradores devem cadastrar os meios de
pagamento disponíveis, como boletos bancários, cartões de crédito, PIX etc, especificando
detalhes de cada formato. Administradores também podem consultar os clientes da plataforma,
consultar e avaliar solicitações de reembolso, bloquear compras por suspeita de fraudes etc.
Já os donos de negócios devem ser capazes de cadastrar suas empresas e ativar uma conta
escolhendo quais meios de pagamento serão utilizados. Devem ser cadastrados também os
planos disponíveis para venda, incluindo seus valores e condições de desconto de acordo com
o meio de pagamento. E a cada nova venda realizada, devem ser armazenados dados do
cliente, do produto selecionado e do meio de pagamento escolhido. Um recibo deve ser emitido
para cada pagamento e esse recibo deve ser acessível para os clientes finais, alunos da
CodePlay no nosso contexto.

### Configurações
* Ruby 3.0.1
* Rails 6.1.3.2
* Testes:
  - Rspec
  - Capybara
  - Shoulda Matchers

### Como iniciar o projeto 
* Clone o projeto para sua máquina, e dentro da pasta do projeto, rode o comando ```bin/setup``` em seu terminal
* Você pode utilizar o comando ```rails s``` para ver a aplicação funcionando localmente no endereço ```http://localhost:3000```


### Testes
* Para executar os testes, utilize o comando ```rspec```

## Informações deste projeto
### Administradores
* Administradores não possuem página de registro e devem ser registrados pelo console e **precisam** possuir um e-mail com o dominio @paynow.com.br.
* Login de administradores deve ser feito acessando new_admin_session_path: ```http://localhost:3000/admins/sign_in```

### Usuários
* Usuários possuem roles de ```customer_admin``` ou ```user``` e não podem ser registrar com emails dos dominios: **Google**, **Yahoo**, **Hotmail** e **Paynow**
# Populando o banco de dados
* Para popular o banco com informaçoes pré definidas, use o comando ```rails db:seed```
* Administrador gerado: email: ```ademir@paynow.com.br```, senha: ```123456```
* Usuario administrador de empresa cliente gerado: email: ```john_doe@codeplay.com.br```, senha: ```123456```
* Usuario funcionario de empresa cliente gerado: email: ```john_doe2@codeplay.com.br```, password: ```123456```

## API
### Registro de cliente final
#### __post '/api/v1/final_customers'__
* o endpoint para criação e associação de um cliente final e uma empresa cliente PayNow, espera receber os seguintes parâmetros:
```
{
	'final_customer':
	{
		'name': 'Nome do cliente',
		'cpf': 'Apenas números e com 11 caractéres'
	},
	'company_token': 'Token alfanumérido da empresa já cadastrada'
}
```
#### Possíveis Respostas
* HTTP Status: 201 - Cliente registrado com sucesso

Exemplo:
```
{
	name: "Fulano Sicrano",
	cpf: "98765432101",
	token: "txrzoRCiGngB8Fr6zgKB"
}
```
* HTTP Status: 412 - Parâmetros inválidos para criação de cliente (parametros em branco ou não respeitando as validações)

Exemplo:
```
{
	message: 'Parâmetros Inválidos'
}
```
* HTTP Status: 412 - Token Inválido (da empresa)

Exemplo:
```
{
	message: 'Token Inválido'
}
```
#### __post '/api/v1/orders'__
* o endpoint para criação e associação de um cliente final e uma empresa cliente PayNow, espera receber os seguintes parâmetros:

* Para Boletos:
```
{
  order: 
  {
    company_token: Token da empresa cliente, 
    product_token: Token do produto a ser vendido, 
    final_customer_token: Token do cliente final,
    choosen_payment: "boleto",
    adress: Endereço a ser enviado o boleto
  }
}
```

* Para Cartão:
```
{
  order: 
  {
    company_token: Token da empresa cliente, 
    product_token: Token do produto a ser vendido, 
    final_customer_token: Token do cliente final,
    choosen_payment: "card",
    card_number: Numero do cartão, com 16 dígitos, apenas numeros
    printed_name: Nume impresso no cartão,
    verification_code: Código de segurança, com 3 digitos, apenas numeros
  }
}
```

* Para PIX:
```
{
  order: 
  {
    company_token: Token da empresa cliente, 
    product_token: Token do produto a ser vendido, 
    final_customer_token: Token do cliente final,
    choosen_payment: "pix",
  }
}
```
#### Possíveis Respostas
* HTTP Status: 201 - Compra registrada com sucesso.

Exemplo boleto:
```
{
	token: "dwx5UBuwxZgqaN9hawgo", 
	status: "pendente", 
	original_price: "100.0",
	final_price: "95.0", 
	choosen_payment: "boleto", 
	adress": "fulano_sicrano@gmail.com", 
	company: { token: "y3vxtTPta2ykM64o2PL9" },
	product: { token: "o49aXMmnTVrET2GEFHfM" },
	final_customer: { token: "CAjaMeHyKD3P74jWyE9E }
}
```

Exemplo cartão:
```
{
	token: "N3zs82YGaX6hyeXfFxVP",
	status: "pendente", 
	original_price: "100.0", 
	final_price: "100.0", 
	choosen_payment: "card", 
	card_number: "9876543210123456", 
	printed_name: "Fulano Sicrano", 
	verification_code: "000", 
	company: { token: "LP4s3FwvntrGfm6UokkL" }, 
	product: { token: "1JawCh5m2qiYEkn5ucav" },
	final_customer: { token: "tZ5qW2jR78ZQpKwUextV" }
}
```

Exemplo PIX:
```
{
	token: "GtLsEJpmFYkRfSXWTu2r",
	status: "pendente", 
	original_price: "100.0", 
	final_price: "90.0", 
	choosen_payment: "pix", 
	company: { token: "uZGAM86JoyHmBv3WdnSg" },
	product: { token: "mPZEmrARA7fgLAL3LzPr" },
	final_customer: { token: "3nbAU317qitpUaXMEgEm"}
}
```
* HTTP Status: 412 - Parâmetros inválidos para criação da compra (parametros em branco ou não respeitando validações)

Exemplo:
```
{
	message: 'Parâmetros Inválidos'
}
```
* HTTP Status: 412 - Token Inválido (da empresa, cliente ou produto)

Exemplo:
```
{
	message: 'Token Inválido'
}
```
#### __get '/api/v1/orders'__
* o endpoint para consulta de pedidos por tipo de pagamento e data de criação, espera os seguintes parametros:
```
{
  company: { token: Token da empresa que deseja consultar },
  created_at: Data a partir da qual deseja verificar,
  choosen_payment: tipo de pagamento que deseja verificar
}
```
#### Possíveis Respostas
* HTTP Status: 200 - Busca realizada com sucesso.

Exemplo:
```
[{
	token: "PpfEBEbdRXGEhc5MX3sP",
	status: "pendente", 
	original_price: "100.0", 
	final_price: "95.0", 
	choosen_payment: "boleto", 
	adress: "fulano_sicrano@gmail.com", 
	card_number: null,
	printed_name: null,
	verification_code: null, 
	created_at: "2021-06-15T20:29:21.921-03:00", 
	updated_at: "2021-06-15T20:29:21.921-03:00",
	company: { token: "uHaEH7qwA4Aad7voit1Y" },
	product: { token: "NwriBSnC7jVNyF4WFpgi" },
	final_customer: { token: "wGQxV4EeepNFS2Suo2Xk" }
}]
```
* HTTP Status: 200 - Busca realizada com sucesso, mas sem resultados
```
{ 
	message: 'Nenhum resultado encontrado' 
}
```
* HTTP Status: 404 - Token Inválido (da empresa)

Exemplo:
```
{
	message: 'Token Inválido'
}
```
#### __put "/api/v1/orders/#{order.token}"__
* o endpoint para atualizar do status de pedidos , espera os seguintes parametros:
```
{
  order: {
          status: Status a ser enviado
          response_code: Código do banco referente ao status do pagamento
         }
}
```
* HTTP Status: 200 - Status atualizado com sucesso:

Exemplo:
```
{
	status: "aprovado",
	choosen_payment: "boleto",
	token: "aBv7Faaq3r3jK8Bp5Uvs",
	original_price: "100.0",
	final_price: "95.0",
	adress: "fulano_sicrano@gmail.com",
	card_number: nil,
	printed_name: nil,
	verification_code: nil,
	company: { token: "428VxSpNtsqM6K8hX81k" },
	product: {token: "LMnxyjwMXS5PuR4qAjev"}, 
	final_customer: { token: "hnEQzZW3agK5iCmYw8f1" }, 
	order_histories: [{ response_code: "05 - Cobrança efetivada com sucesso" }]
}
```
* HTTP Status: 404 - Token Inválido (da compra)

Exemplo:
```
{
	message: "Token Inválido"
}
```
* HTTP Status: 412 - Parâmetros Inválidos

Exemplo:
```
{
	message: "Parâmetros Inválidos"
}
```