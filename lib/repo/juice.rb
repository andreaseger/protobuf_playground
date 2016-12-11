# frozen_string_literal: true
require 'wire/types_pb'
require 'protobuf_refinements'

require 'mongo'
require 'singleton'

module Repo
  class Juice
    using ProtobufRefinements
    def self.save(juice:)
      collection.insert_one(wire_to_mongo(juice))
      find(id: juice.id)
    end

    def self.find(id:)
      doc = collection.find(_id: id).first
      mongo_to_wire(doc)
    end

    def self.all
      collection.find.map do |doc|
        mongo_to_wire(doc)
      end
    end

    #--------------------

    def self.wire_to_mongo(obj)
      data = obj.to_h
      data[:_id] = data.delete(:id)
      data[:created_at] = data.delete(:created_at).to_time
      data[:updated_at] = data.delete(:updated_at).to_time
      data
    end

    def self.mongo_to_wire(doc)
      doc = doc.to_h
      doc['id'] = doc.delete('_id')
      doc['created_at'] = doc.delete('created_at').to_protobuf
      doc['updated_at'] = doc.delete('updated_at').to_protobuf
      doc.keys.each do |key|
        doc[key.to_sym] = doc.delete(key)
      end
      Wire::Juice.new(doc)
    end

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
