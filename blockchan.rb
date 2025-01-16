# frozen_string_literal: true
require 'digest'
require 'pp'

class FairyBlock
  attr_reader :data
  attr_reader :hash
  attr_reader :nonce

  def initialize(data)
    @data = data
    @hash, @nonce = compute_proof_of_work('00')
  end

  def compute_proof_of_work(difficulty)
    nonce = 0
    loop do
      hash = Digest::SHA256.hexdigest("#{nonce}#{data}")
      if hash.start_with?(difficulty)
        return [hash, nonce]
      else
        nonce += 1
      end
    end
  end

end

# mining blocks

pp FairyBlock.new('Hello, Fairies!')
pp FairyBlock.new('Hello, Fairies! - Hello, Fairies! - Hello, Fairies!')
pp FairyBlock.new('Zakaria')
pp FairyBlock.new('TEST TEST TEST')


