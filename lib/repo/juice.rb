# frozen_string_literal: true
require 'mongo'
require 'singleton'

module Repo
  class Juice
    def self.save(juice:)
      data = juice.to_h
      data[:_id] = data.delete(:id)
      collection.insert_one(data)
      juice
    end

    def self.find(id:)
      doc = collection.find(_id: id).first
      doc['id'] = doc['_id']
      Model::Juice.new(doc)
    end

    def self.all
      collection.find.to_a.map do |doc|
        doc['id'] = doc.delete('_id')
        Model::Juice.new(doc)
      end
    end

    def self.delete(id:)
      collection.delete_one(_id: id)
    end

    #--------------------

    def self.collection
      Mongo.instance.client[:juices]
    end
  end

  class Mongo
    include Singleton
    URI = "mongodb://127.0.0.1:27017/protobuf_playground_#{ENV['RACK_ENV']}"

    attr_reader :client
    def initialize
      @client = ::Mongo::Client.new(URI)
    end
  end
end
