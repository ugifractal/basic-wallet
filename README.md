# README

## Setup

```
mkdir basic-wallet
cd basic-wallet
git clone <repo_url> .
bundle install
```

Update config/database.yml to match your db setup
```
bundle exec rails db:create
bundle exec rails db:schema:load
bundle exec rails db:seed
```

To run app
```bash
bundle exec rails s
```

Open rails console:
```bash
bundle exec rails c
```

Getting `api_key` from user:
```
User.first.api_key
```

Getting `api_key` from team:
```
Team.first.api_key
```

To support reset daily market, need to run
```ruby
RequestedStockTransaction.cancel_pending_request
```
at end of market like 04.00 pm, this can be run using `crontab`

## API
Please replace sample API key, using rails console

### Get balance of user (GET):

```bash
curl -L 'http://localhost:3000/api/v1/wallet' \
-H 'x-api-key: d4ykm2v2uxCvOOgzTjnh1Q'
```

Sample response
```json
{
    "wallet": {
        "id": 8,
        "balance": 100000,
        "balance_float": 1000.0,
        "user": {
            "id": 10,
            "email": "ugidmtest@gmail.com"
        }
    }
}
```

### Transfer (POST)
```bash
curl -L 'http://localhost:3000/api/v1/wallet/transfer' \
-H 'x-api-key: d4ykm2v2uxCvOOgzTjnh1Q' \
-H 'Content-Type: application/json' \
--data-raw '{
    "email": "team@gmail.com",
    "amount": 100
}'
```

`email` : destination
`amount`: amount in x 100 format

Sample response:
```json
{
    "wallet": {
        "id": 8,
        "balance": 99900,
        "balance_float": 999.0,
        "user": {
            "id": 10,
            "email": "ugidmtest@gmail.com"
        }
    }
}
```

### Show transactions (GET)
```bash
curl -L 'http://localhost:3000/api/v1/wallet/transactions' \
-H 'x-api-key: d4ykm2v2uxCvOOgzTjnh1Q'
```

Sample output:
```json
{
    "transactions": [
        {
            "id": 52,
            "amount": 100,
            "created_at": "2024-08-15T11:51:58.766Z",
            "type": "debit",
            "amount_float": 1.0
        },
        {
            "id": 51,
            "amount": 100000,
            "created_at": "2024-08-15T11:47:54.950Z",
            "type": "credit",
            "amount_float": 1000.0
        }
    ]
}

```

### Show Portfolio

```bash
curl -L 'http://localhost:3000/api/v1/portfolio' \
-H 'x-api-key: QtBkZ66cjpWQq_jYep85RA'
```

Sample output for team
```json
{
    "portfolio": {
        "id": 9,
        "stocks": {
            "GOTO": 1000
        }
    }
}
```

### Request to Sell stock
This need to run at open market time like 08:00am to 04:00pm
This is just add to queue, real transaction will be made when matching ```buy request``` exist via after create/commit callback.

```bash
curl -L 'http://localhost:3000/api/v1/portfolio/request_to_sell' \
-H 'x-api-key: QtBkZ66cjpWQq_jYep85RA' \
-H 'Content-Type: application/json' \
-d '{
    "symbol": "GOTO",
    "quantity": 1,
    "price": 5100
}'
```

Sample response
```json
{
    "requested_stock_transactions": [
        {
            "id": 61,
            "transaction_type": "sell",
            "price": 5100,
            "quantity": 1,
            "created_at": "2024-08-15T12:05:50.945Z",
            "status": "pending"
        }
    ]
}
```

### Request to Buy stock (Bid)
This need to run at open market time like 08:00am to 04:00pm
This is just add to queue, real transaction will be made when matching ```sell request``` exist via after create/commit callback.

```bash
curl -L 'http://localhost:3000/api/v1/portfolio/request_to_buy' \
-H 'x-api-key: d4ykm2v2uxCvOOgzTjnh1Q' \
-H 'Content-Type: application/json' \
-d '{
    "symbol": "GOTO",
    "quantity": 2,
    "price": 5100
}'
```

Sample response
```json
{
    "requested_stock_transactions": [
        {
            "id": 60,
            "transaction_type": "buy",
            "price": 5100,
            "quantity": 2,
            "created_at": "2024-08-15T12:05:19.697Z",
            "status": "pending"
        }
    ]
}
```

### Show today market transaction
```bash
curl -L 'http://localhost:3000/api/v1/portfolio/latest_transactions' \
-H 'x-api-key: d4ykm2v2uxCvOOgzTjnh1Q'
```

Sample response
```json
{
    "requested_stock_transactions": [
        {
            "id": 60,
            "transaction_type": "buy",
            "price": 5100,
            "quantity": 2,
            "created_at": "2024-08-15T12:05:19.697Z",
            "status": "pending"
        }
    ]
}
```

For Latest Stock Price API, The code was created, but not used on the logic of bidding.

Here how to use:

```ruby
StockPriceApi.api_key = "a1cad03b4fmsh48357b5f6670341p151d54jsn810385c5df9a"
list = StockPriceApi::Stock.list
```

The API endpoint also provided:
```bash
curl -L 'http://localhost:3000/api/v1/stocks/info/NIFTY 50' \
-H 'x-api-key: d4ykm2v2uxCvOOgzTjnh1Q'
```

Sample output:
```json
{
    "info": {
        "identifier": "NIFTY 50",
        "change": 4.75,
        "dayHigh": 24196.5,
        "dayLow": 24099.7,
        "lastPrice": 24143.75,
        "lastUpdateTime": "14-Aug-2024 16:00:00",
        "meta": {
            "companyName": null,
            "industry": null,
            "isin": null
        },
        "open": 24184.4,
        "pChange": 0.02,
        "perChange30d": -1.8,
        "perChange365d": 24.23,
        "previousClose": 24139,
        "symbol": "NIFTY 50",
        "totalTradedValue": 278344405754.84,
        "totalTradedVolume": 303254705,
        "yearHigh": 25078.3,
        "yearLow": 18837.85
    }
}
```

### Models description:
- `UserBase`: The base model for `users` table
- `User`: Extend from `UserBase` used for regular user
- `Team`: Extend from `UserBase` just like User, making separated in case need different field
- `Transaction`: Keep state for transaction between user to user, user to team or team to team
- `StockTransaction`: Keep state for trading stocks between user to user, user to team or team to team
- `RequestedStockTransaction`: Handle request for buy and sell, this may be like `order`. When matched request found, then `StockTransaction` from `Portfolio and `Transaction` from `Wallet` would be exchanged / moved.
- `Wallet`: maintain wallet information for `User` and `Team`
- `Portfolio`: maintain stocks information for `User` and `Team`

Feel free to ask to ugidmtest@gmail.com if you have questions.







