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
