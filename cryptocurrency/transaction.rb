# frozen_string_literal: true

class TransactionPool
  attr_reader :from_sender
  attr_reader :to_receiver
  attr_reader :data
  attr_reader :qty
  attr_reader :transactions
  attr_reader :max_transactions

  def initialize
    @transactions = []
    @max_transactions = 2
  end

  def add_to_pool(sender, receiver, data, quantity)
    @from_sender = sender
    @to_receiver = receiver
    @data = data
    @qty =  quantity

    transactions.append(
      {
        from: @from_sender,
        to: @to_receiver,
        what: @data,
        qty: @qty
      }
    )
  end

  def get_pool
    @transactions
  end
end
