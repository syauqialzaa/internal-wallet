class StocksController < ApplicationController
  before_action :authorized
  before_action :set_walletable, only: [:invest, :update_price]
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def index
    stocks = Stock.all
    render json: {
      transactions: ActiveModelSerializers::SerializableResource.new(stocks, each_serializer: StockSerializer)
    }, status: :ok
  end

  def invest
    stock = Stock.find_by(id: params[:stock_id])
    amount = params[:amount].to_d

    investor_wallet = Wallet.find_by(walletable: @walletable.entity)
    stock_wallet = Wallet.find_by(walletable: stock.entity)

    if investor_wallet.balance < amount
      return render json: { message: "Insufficient funds" }, status: :unprocessable_entity
    end

    transaction = Transaction.create!(
      sender_wallet: investor_wallet,
      receiver_wallet: stock_wallet,
      amount: amount,
      transaction_type: :debit 
    )
    Transaction.create!(
      sender_wallet: investor_wallet,
      receiver_wallet: stock_wallet,
      amount: amount,
      transaction_type: :credit
    )

    render json: {
      message: "Successfully invested #{amount} in stock #{stock.ticker_symbol}",
      data: {
        wallet_balance: investor_wallet.reload.balance,
        transaction: transaction
      }
      }, status: :ok
  end

  def update_price
    stock = Stock.find_by(id: params[:stock_id])
    new_price = params[:new_price].to_d
    old_price = stock.price.to_d
    stock.update(price: new_price)

    investor_wallet = Wallet.find_by(walletable: @walletable.entity)
    stock_wallet = Wallet.find_by(walletable: stock.entity)

    if new_price > old_price
      profit = (new_price - old_price) * stock.amount_invested(investor_wallet, stock_wallet)
      Transaction.create!(
        sender_wallet: stock_wallet,
        receiver_wallet: investor_wallet,
        amount: profit,
        transaction_type: :credit
      )
      message = "Stock price increased! Investor profit #{profit}"
    else
      loss = (old_price - new_price) * stock.amount_invested(investor_wallet, stock_wallet)
      Transaction.create!(
        sender_wallet: stock_wallet,
        receiver_wallet: investor_wallet,
        amount: loss,
        transaction_type: :debit
      )
      message = "Stock price decreased! Investor loss #{loss}"
    end

    render json: {
      message: message,
      data: {
        wallet_balance: investor_wallet.reload.balance,
        stock: StockSerializer.new(stock)
      }
    }, status: :ok
  end

  private
  def set_walletable
    if params[:user_id]
      @walletable = User.find(params[:user_id])
      authorize_access(@walletable.id)
    elsif params[:team_id]
      @walletable = Team.find(params[:team_id])
      authorize_access(@walletable.team_lead)
    end
  end

  def authorize_access(walletable)
    unless walletable == current_user&.id
      render json: { message: "Unauthorized access" }, status: :unauthorized
    end
  end
  
  def handle_invalid_record(error)
    render json: { errors: error.record.errors.full_messages }, status: :unprocessable_entity
  end

  def handle_record_not_found(error)
    render json: { error: "Stock not found" }, status: :not_found
  end
end

