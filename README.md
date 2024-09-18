<h1 align="center"><b>Internal Wallet API</b></h1>

**Atask**: Technical Test.
</br>
https://www.atask.net/
</br>

**Goal**:
</br>
Internal wallet transactional system (API)

## Tech Stack

| Technologies       | Version           |
| ------------------ | ----------------- |
| Ruby (RVM)         | v3.1.2 (v1.29.12) |
| Ruby On Rails      | v7.0.4            |
| PostgreSQL         | v14.10            |

## Used Gems

| Dependencies     | Gems                     |
| ---------------- | ------------------------ |
| JWT Token        | jwt                      |
| Hash function    | bcrypt                   |
| ERD              | rails-erd                |
| Cors             | rack-cors                |
| Serializers      | active_model_serializers |
| LatestStockPrice | latest_stock_price       |
| Debugging        | byebug                   |

## Usage

1. Create rails local credentials. If using VS Code as code editor write this command:
   ```bash
   EDITOR="code --wait" rails credentials:edit
   ```
   Add these line and adjust it with your local database configuration:
   ```yaml
   postgresql:
     rails_max_threads: 5
     database_url_dev: "postgresql://username:password@localhost:5432/db_dev?schema=public"
     database_url_test: "postgresql://username:password@localhost:5432/db_test?schema=public"
   ```
   Then save it
   
2. run `bundle install`
3. run `rails db:create db:migrate`
4. run `rails db:seed` for running seed **Stocks** data migration
5. run `rails s`

## Routes

- Users
  - Register
  ```ruby
    POST request: "/users"
    params: {
      "name": "John Doe",
      "email": "johndoe@email.com",
      "password": "password123"
    }
  ```
  - Login
  ```ruby
    POST request: "/auth/login"
    params: {
      "email": "johndoe@email.com",
      "password": "password123"
    }
  ```
  - Logout
  ```ruby
    DELETE request: "/auth/logout"
    auth_type: "Bearer Token"
  ```
- Teams
  - Create Team
  ```ruby
    POST request: "/teams"
    auth_type: "Bearer Token",
    params: {
      "name": "First Team"
    }
  ```
- Stocks
  - Stocks
  ```ruby
    GET request: "/stocks"
    auth_type: "Bearer Token"
  ```
  - Invest
  ```ruby
    POST request: "/<entity>/<:entity_id>/stocks/invest"
    auth_type: "Bearer Token",
    params: {
      "stock_id": "388bd477-e0be-4db2-9273-51d66e6d3efe",
      "amount": 100
    }

    example_url: "{{host}}/users/31434c57-1791-42c7-a52d-e5734e2675fb/stocks/invest"
  ```
  - Update Price
  ```ruby
    POST request: "/<entity>/<:entity_id>/stocks/update_price"
    auth_type: "Bearer Token",
    params: {
      "stock_id": "388bd477-e0be-4db2-9273-51d66e6d3efe",
      "new_price": 150
    }

    example_url: "{{host}}/users/31434c57-1791-42c7-a52d-e5734e2675fb/stocks/update_price"
  ```
- Wallets
  - Show Wallet
  ```ruby
    GET request: "/<entity>/<:entity_id>/wallets"
    auth_type: "Bearer Token"
  ```
  - Top Up Wallet
  ```ruby
    POST request: "/<entity>/<:entity_id>/wallets/top_up"
    auth_type: "Bearer Token",
    params: {
      "amount": 1000
    }

    example_url: "{{host}}/users/31434c57-1791-42c7-a52d-e5734e2675fb/wallets/top_up"
  ```
  - Send Wallet
  ```ruby
    POST request: "/<entity>/<:entity_id>/wallets/send_wallet"
    auth_type: "Bearer Token",
    params: {
      "amount": 100,
      "receiver_wallet_id": "5705b4bd-d3c0-495c-bf96-69014c243886"
    }

    example_url: "{{host}}/users/31434c57-1791-42c7-a52d-e5734e2675fb/wallets/top_up"
  ```
- Transactions
  - Transactions
  ```ruby
    GET request: "/<entity>/<:entity_id>/wallets/transactions"
    auth_type: "Bearer Token"

    example_url: "{{host}}/users/31434c57-1791-42c7-a52d-e5734e2675fb/wallets/transactions
  ```
- Latest Stock Price
  - Show Wallet
    ```ruby
      GET request: "/latest_stocks/V1/price_all"
      auth_type: "Bearer Token"
    ```

## Features

- User can register
- User can login
- User can logout
- User can create a Team
- User have a Wallet when created
- Team have a Wallet when created
- Stock have a Wallet when created
- User can show all Stocks in database
- User can `invest` to a Stock
- User can `update_price` the Stock then profit/loss from Stock
- Team (team lead) can `invest` to a Stock
- Team (team lead) can `update_price` the Stock then profit/loss from Stock
- User can show their Wallet
- Team (team lead) can show their Wallet
- User can top up their Wallet balance
- Team (team lead) can top up their Wallet balance
- User can send Wallet to Entities (User, Team, Stock)
- Team (team lead) can send Wallet to Entities(User, Team, Stock)
- User can show all their Transactions
- Team (team lead) can show all their Transactions
- User can show `price_all` Latest Stock Price
- All changes in Wallet balance (debit/credit) are recorded in Transactions Table

## Entity Relational Database

![erd](/app/assets/images/erd.png)
Generate ERD file using GraphVIZ and run `bundle exec erd`.

## Implementation
Since each entity subclass (users, teams, stocks) each has different properties, instead of using STI, a possible approach is **Polymorphic Association**.

**Table Entities for Polymorphic Reference**
Create one main table used for **Polymorphic Association** on `wallets` and `transactions`. However, individual entities like `users`, `teams`, and `stocks` still have their own tables to store specialized information.

- **Table `entities` for Polymorphic Reference**
Acts as an **abstraction** for all entities (Users, Teams, Stocks) in the system. Each entity will have an **ID** in this table, but the details will be stored in their own tables (`users`, `teams`, `stocks`).
- **The `users` table for User Details**
Stores specific details for **Users** that are not needed by **Teams** or **Stocks**.
- **Table `teams` for Team Details**
Stores specific information that is only needed by **Teams**.
- **Table `stocks` for Stocks Details**
Stores data specific to **Stocks**, such as stock code and price.
- **Table `wallets` for Polymorphic Association**
Stores wallet information, which is associated with various entities using **Polymorphic Association**.
- **Table `transactions` for Transaction Logging**
Records all transactions that occur between different wallets.

## How simply this project run

- Each entity (User, Team, Stock) has their own table that stores relevant information.
- Each entity also has a **wallet** that is linked via **Polymorphic Association** (`walletable_id` and `walletable_type`) in the `wallets` table.
- Inter-wallet **transactions** are recorded in the `transactions` table, with the sending and receiving wallets, and the transaction type (debit or credit) recorded using enums.
