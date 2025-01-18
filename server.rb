# frozen_string_literal: true
require 'sinatra'
require 'pp'
require 'json'
require 'sinatra/cors'
require_relative 'fairy_chain'
require_relative 'fairy_block'

class FairyBlockchainServer < Sinatra::Base
  register Sinatra::Cors
  set :allow_origin, "http://localhost:5173"
  set :allow_methods, "GET,HEAD,POST"
  set :allow_headers, "content-type,if-modified-since"

  @@blockchain = FairyChain.new

  before do
    content_type :json
  end

  get '/fairychain' do
    {
      fairychain: @@blockchain.blockchain,
      length: @@blockchain.blockchain.length
    }.to_json
  end

  post '/mine' do
      data = JSON.parse(request.body.read)['data']
      if @@blockchain.blockchain.empty?
        prev_hash = '0000000000000000000000000000000000000000000000000000000000000000'
      else
        prev_hash = @@blockchain.blockchain[-1].hash
      end

      new_block = FairyBlock.new(data, prev_hash)
      block = @@blockchain.add_block(new_block)

      {
        message: 'Thanks Fairy, new block mined!',
        block: block
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

FairyBlockchainServer.run! if __FILE__ == $0
