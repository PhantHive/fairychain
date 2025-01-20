# frozen_string_literal: true
require 'digest'
require 'pp'

class FairyBlock

  # block header
  attr_reader :hash
  # previous block header
  attr_reader :prev_hash

  # elements to compute header
  attr_reader :nonce
  attr_reader :time
  attr_reader :difficulty
  attr_reader :merkle_root

  # body
  attr_reader :transactions

  def initialize(merkle_root, transactions, prev_hash, difficulty: '0000')
    @merkle_root = merkle_root
    @transactions = transactions
    @prev_hash = prev_hash
    @difficulty = difficulty
    @hash, @nonce, @time = compute_proof_of_work(difficulty)
  end

  def hash
    Digest::SHA256.hexdigest("#{nonce}#{time}#{difficulty}#{prev_hash}#{merkle_root}")
  end

  def compute_proof_of_work(difficulty)
    nonce = 0
    loop do
      time = Time.now.to_i
      hash = Digest::SHA256.hexdigest( "#{nonce}#{time}#{difficulty}#{prev_hash}#{merkle_root}" )
      if hash.start_with?(difficulty)
        pp "Success: #{nonce} - Hash: #{hash} - Difficulty: #{difficulty} - Data: #{transactions}"
        return [hash, nonce, time]
      else
        nonce += 1
      end
    end
  end

    def to_json(*args)
    {
      data: @transactions,
      hash: @hash,
      prev_hash: @prev_hash,
      nonce: @nonce,
      difficulty: @difficulty,
      time: @time
    }.to_json(*args)
  end
end


