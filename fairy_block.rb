# frozen_string_literal: true
require 'digest'
require 'pp'

class FairyBlock
  attr_reader :data
  attr_reader :prev_hash
  attr_reader :nonce
  attr_reader :difficulty
  attr_reader :time

  def initialize(data, prev_hash, difficulty: '0000')
    @data = data
    @prev_hash = prev_hash
    @difficulty = difficulty
    @hash, @nonce, @time = compute_proof_of_work(difficulty)
  end

  def hash
    Digest::SHA256.hexdigest("#{nonce}#{time}#{difficulty}#{prev_hash}#{data}")
  end

  def compute_proof_of_work(difficulty)
    nonce = 0
    loop do
      time = Time.now.to_i
      hash = Digest::SHA256.hexdigest( "#{nonce}#{time}#{difficulty}#{prev_hash}#{data}" )
      if hash.start_with?(difficulty)
        pp "Success: #{nonce} - Hash: #{hash} - Difficulty: #{difficulty} - Data: #{data}"
        return [hash, nonce, time]
      else
        nonce += 1
      end
    end
  end

    def to_json(*args)
    {
      data: @data,
      prev_hash: @prev_hash,
      nonce: @nonce,
      difficulty: @difficulty,
      time: @time
    }.to_json(*args)
  end
end


