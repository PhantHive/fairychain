require 'minitest/autorun'
require 'pp'
require_relative '../cryptocurrency/transaction'
require "merkle_tree"

class TransactionPoolTest < Minitest::Test
  def setup
    # Runs before each test
    @pool = TransactionPool.new
  end

  def test_new_pool_is_empty
    assert_empty @pool.get_pool
  end

  def test_add_transaction_to_pool
    @pool.add_to_pool("sender1", "receiver1", "test data", 100)
    pp @pool
    assert_equal 1, @pool.get_pool.length
  end

  def test_transaction_hash_is_created
    @pool.add_to_pool("sender1", "receiver1", "test data", 100)
    refute_nil @pool.get_pool.first[:hash]
  end

  def test_even_loop_with_odd_transactions
    @pool.add_to_pool("sender1", "receiver1", "test1", 100)
    @pool.add_to_pool("sender2", "receiver2", "test2", 200)
    @pool.add_to_pool("sender3", "receiver3", "test3", 300)
    pp @pool

    assert_equal false, @pool.even_loop(@pool.get_pool)
  end

  def test_merkle_root_with_even_transactions
    @pool.add_to_pool("sender1", "receiver1", "test1", 100)
    @pool.add_to_pool("sender2", "receiver2", "test2", 200)

    merkle_root = @pool.find_merkle_root(@pool.get_pool)
    refute_nil merkle_root
  end
end