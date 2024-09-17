# Stocks
stocks = Stock.create!([
  {
    ticker_symbol: "AAPL",
    price: 150.25
  },
  {
    ticker_symbol: "MSFT",
    price: 305.50
  },
  {
    ticker_symbol: "AMZN",
    price: 137.80
  },
  {
    ticker_symbol: "TSLA",
    price: 250.10
  },
  {
    ticker_symbol: "GOOGL",
    price: 2765.60
  }
])

# Create Entity {Polymorphic Associations} Stock
stocks.each do |stock|
  stock.create_entity!
end

# Create Wallets associated with Entity
Wallet.create!([
  {
    walletable: stocks[0].entity,
    balance: 10000.00
  },
  {
    walletable: stocks[1].entity,
    balance: 20000.00
  },
  {
    walletable: stocks[2].entity,
    balance: 15000.00
  },
  {
    walletable: stocks[3].entity,
    balance: 25000.00
  },
  {
    walletable: stocks[4].entity,
    balance: 50000.00
  }
])