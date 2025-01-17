# frozen_string_literal: true
require 'pp'
require_relative 'fairy_block'


class FairyChain
  attr_reader :blockchain

  def initialize
    @blockchain = []
  end

  def add_block(block)
    @blockchain << block
  end

  def validate_fairychain?
    @blockchain.each_with_index do |block, index|
      if index == 0
        init_hash = '0000000000000000000000000000000000000000000000000000000000000000'
        unless block.instance_variable_get(:@prev_hash) == init_hash
          pp "Initial block hash is not equal to the initial hash"
          return false
        end
      else
        prev_block = @blockchain[index - 1]
        unless block.instance_variable_get(:@prev_hash) == prev_block.instance_variable_get(:@hash)
          pp "Previous hash is not equal to the previous block's hash"
          return false
        end
      end
      unless block.instance_variable_get(:@hash).start_with?(block.difficulty)
        return false
      end
    end
  end

  def print_fairychain
    @blockchain.each do |block|
      pp "Data: #{block.data}"
      pp "Prev hash: #{block.prev_hash}"
      pp "Nonce: #{block.nonce}"
      pp "Difficulty: #{block.difficulty}"
      pp "Time: #{Time.at(block.time)}"
      pp "Hash: #{block.hash}"
      pp "--------------------------------"
    end
  end
end

# mining blocks

init_hash = '0000000000000000000000000000000000000000000000000000000000000000'
b0 = FairyBlock.new('Hello, Fairies!', init_hash)
b1 = FairyBlock.new('Hello, Fairies! I repeat HELLO FAIRIES!', b0.hash)
b2 = FairyBlock.new('That\'s me Mario!', b1.hash)
b3 = FairyBlock.new('TEST TEST TEST', b2.hash)


blockchain = FairyChain.new
blockchain.add_block(b0)
blockchain.add_block(b1)
blockchain.add_block(b2)
blockchain.add_block(b3)


if blockchain.validate_fairychain?
  puts "Blockchain is operational"
else
  puts "Blockchain corrupted!"
end

blockchain.print_fairychain

