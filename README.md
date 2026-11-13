# Gerenciador de Tarefas — Flutter + Laravel

## Descrição do projeto

O Gerenciador de Tarefas é um aplicativo desenvolvido em Flutter/Dart que permite ao usuário organizar suas atividades pessoais por meio de uma interface simples e intuitiva.

O aplicativo consome uma API REST desenvolvida em Laravel, responsável pela autenticação, armazenamento e gerenciamento das tarefas, categorias e etiquetas.

Este projeto foi desenvolvido como trabalho acadêmico, aplicando conceitos de arquitetura em camadas, integração com APIs REST, programação assíncrona e gerenciamento de dados.

## Desenvolvedor

**Aluno:** João Pedro Soutier

## Tecnologias utilizadas

- Flutter e Dart
- Laravel e PHP
- MySQL
- Docker
- API REST
- Pacote `http`
- Pacote `go_router`
- Git e GitHub

## Back-end escolhido

**Opção A — API Laravel**

O aplicativo utiliza uma API Laravel para autenticação e gerenciamento dos dados.

**Repositório da API:** https://github.com/Joao-Pedro16230/api-tarefas

## Funcionalidades

- Autenticação de usuário por e-mail e senha.
- Visualização de um dashboard com indicadores.
- Listagem das tarefas cadastradas.
- Cadastro de novas tarefas.
- Edição de tarefas existentes.
- Exclusão de tarefas.
- Marcação de tarefas como concluídas ou pendentes.
- Associação de categorias e etiquetas às tarefas.
- Definição de data de vencimento.
- Validação de formulários.
- Tratamento de carregamento e erros nas requisições.

## Telas e rotas

| Tela | Rota | Descrição |
|---|---|---|
| Login | `/login` | Autenticação do usuário |
| Dashboard | `/dashboard` | Resumo das tarefas |
| Minhas Tarefas | `/tasks` | Listagem e gerenciamento |
| Adicionar Tarefa | `/tasks/add` | Cadastro de tarefas |
| Editar Tarefa | `/tasks/edit` | Atualização de tarefas |

A navegação utiliza o pacote `go_router`, com rotas nomeadas.

## Arquitetura do projeto

O aplicativo foi organizado em camadas para separar as responsabilidades:

- `core/constants`: constantes e textos reutilizáveis.
- `core/routes`: nomes e caminhos das rotas.
- `core/theme`: cores, estilos e tema visual.
- `core/utils`: validações reutilizáveis.
- `models`: representação dos dados.
- `services`: comunicação com a API Laravel.
- `screens`: telas do aplicativo.
- `widgets`: componentes reutilizáveis.

Os serviços realizam as requisições HTTP e as telas utilizam esses serviços para obter e atualizar os dados.

## Como executar

### 1. Pré-requisitos

É necessário ter instalado:

- Flutter SDK
- Dart SDK
- Docker Desktop
- Git
- Navegador Chrome ou dispositivo compatível com Flutter

### 2. Executar a API Laravel

Clone o repositório da API:

```bash
git clone https://github.com/Joao-Pedro16230/api-tarefas.git
cd api-tarefas
```

Configure o arquivo `.env` de acordo com o ambiente, instale as dependências do Laravel e prepare o banco de dados.

Inicie os contêineres:

```bash
docker compose up -d
```

Execute as migrations e configure um usuário para autenticação.

A API utilizada durante o desenvolvimento está configurada para:

`http://localhost:8030/api`

Documentação Swagger:

`http://localhost:8030/api/documentation`

### 3. Executar o Flutter

Clone o aplicativo:

```bash
git clone https://github.com/Joao-Pedro16230/gerenciador-tarefas-flutter.git
cd gerenciador-tarefas-flutter
```

Instale as dependências:

```bash
flutter pub get
```

Execute no Chrome:

```bash
flutter run -d chrome
```

A API Laravel deve estar em execução para que o aplicativo consiga autenticar o usuário e carregar as tarefas.

## Validação e formatação

Os seguintes comandos foram utilizados durante o desenvolvimento:

```bash
dart format .
flutter analyze
```

A análise estática foi concluída sem problemas identificados.

## Capturas de tela

Adicionar aqui as capturas das cinco telas do aplicativo:

1. Login
2. Dashboard
3. Minhas Tarefas
4. Adicionar Tarefa
5. Editar Tarefa

## Repositórios

**Flutter:** https://github.com/Joao-Pedro16230/gerenciador-tarefas-flutter

**Laravel:** https://github.com/Joao-Pedro16230/api-tarefas
