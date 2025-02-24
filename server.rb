# frozen_string_literal: true
require 'sinatra'
require 'pp'
require 'json'
require 'sinatra/cors'
require_relative 'fairy_chain'
require_relative 'fairy_block'
require_relative 'cryptocurrency/transaction.rb'

class FairyBlockchainServer < Sinatra::Base
  register Sinatra::Cors
  set :allow_origin, "http://localhost:5173"
  set :allow_methods, "GET,HEAD,POST"
  set :allow_headers, "content-type,if-modified-since"

  @@blockchain = FairyChain.new
  @@transaction_pool = TransactionPool.new

  before do
    content_type :json
  end


  post '/transaction' do
    data = JSON.parse(request.body.read)

    required_fields = ['sender_addr', 'receiver_addr', 'data', 'amount']

    missing_fields_arr = required_fields.select { |field| data[field].nil? || data[field].empty?}

    if !missing_fields_arr.empty?
      return {
        error: 'Missing fields',
        message: 'Missing fields'
      }.to_json
    end

    # we try to add to the pool but first we will check if previous pool is full.

    if @@transaction_pool.full_pool?
      pp "MINING PROCESS AUTOMATICALLY FAIRY STARTED"
      mine_new_block(@@transaction_pool, @@blockchain)
      @@transaction_pool = TransactionPool.new
    end

    @@transaction_pool.add_to_pool(data['sender_addr'], data['receiver_addr'], data['data'], data['amount'])

    {
      success: 'Transaction is a success',
      message: 'WOW, a transaction between two fairies happened just now!'
    }.to_json
  end

  # post '/mine' do
  #   mine_new_block
  # end

  get '/latestblock' do
    {
      latestblock: @@blockchain.last_block
    }.to_json
  end

  get '/fairychain' do
    {
      fairychain: @@blockchain.blockchain,
      length: @@blockchain.blockchain.length
    }.to_json
  end

  get '/validate' do
    {
      valid: @@blockchain.validate_fairychain?,
      message: 'Chain validation completed Fairy!',
      fairychain: @@blockchain.blockchain
    }.to_json
  end

  get '/debug' do
    {
      chain_length: @@blockchain.blockchain.length,
      blocks: @@blockchain.blockchain.map { |block|
        {
          hash: block.hash,
          previous_hash: block.previous_hash,
          data: block.data,
          timestamp: block.timestamp
        }
      }
    }.to_json
  end
end


def mine_new_block(transaction_pool, blockchain)
  pool = transaction_pool.get_pool
  merkle_root = transaction_pool.find_merkle_root(pool)

  if blockchain.blockchain.empty?
    prev_hash = '0000000000000000000000000000000000000000000000000000000000000000'
  else
    prev_hash = blockchain.blockchain[-1].hash
  end

  new_block = FairyBlock.new(merkle_root, pool, prev_hash)
  block = blockchain.add_block(new_block)
  pp "MINING ENDED"
  {
    message: 'Thanks Fairy, new block mined!',
    block: block
  }.to_json
end

FairyBlockchainServer.run! if __FILE__ == $0
