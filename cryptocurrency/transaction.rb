# frozen_string_literal: true
require 'digest'

class TransactionPool
  attr_reader :from_sender
  attr_reader :to_receiver
  attr_reader :data
  attr_reader :qty
  attr_reader :transactions
  attr_reader :max_transactions
  attr_reader :time

  def initialize
    @transactions = []
    @max_transactions = 2
  end

  def hash
    Digest::SHA256.hexdigest("#{from_sender}#{to_receiver}#{qty}#{time}#{data}")
  end

  def add_to_pool(sender, receiver, data, quantity)
    @from_sender = sender
    @to_receiver = receiver
    @data = data
    @qty =  quantity
    @time = Time.now

    @transactions.append(
      {
        from: @from_sender,
        to: @to_receiver,
        data: @data,
        qty: @qty,
        hash: hash
      }
    )

    pp @transactions
  end

  def empty_pool?
    @transactions.empty?
  end

  def full_pool?
    @transactions.length == @max_transactions
  end

  def even_loop(transaction_pool)
    transaction_pool.length.even?
  end

  def add_duplicate(transaction_pool)
    transaction_pool.append(transaction_pool.last)
  end

  def merge_hash(transaction_pool)
    first_transaction, second_transaction = transaction_pool.first
    pair_hash = first_transaction[:hash] + second_transaction[:hash]
    Digest::SHA256.hexdigest(pair_hash)
  end

  def find_merkle_root(transaction_pool)
    temp_leaf_transactions = []
    unless even_loop(transaction_pool)
        add_duplicate(transaction_pool)
    end

    transaction_pool = transaction_pool.each_slice(2).to_a

    while transaction_pool.length > 0
      leaf_hash = merge_hash(transaction_pool)
      temp_leaf_transactions.append(leaf_hash)
      transaction_pool.shift(2)
    end

    unless temp_leaf_transactions.length == 1
      find_merkle_root(temp_leaf_transactions)
    end

    puts temp_leaf_transactions
    temp_leaf_transactions.first
  end

  def get_pool
    @transactions
  end
end
