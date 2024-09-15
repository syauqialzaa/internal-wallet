class Transaction < ApplicationRecord
  belongs_to :sender_wallet
  belongs_to :receiver_wallet
end
