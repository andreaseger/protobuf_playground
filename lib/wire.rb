# frozen_string_literal: true
require 'wire/types_pb'
require 'protobuf_refinements'
require 'singleton'

module Google
  module Protobuf
    class Timestamp
      # fix bug -> https://github.com/google/protobuf/pull/2482
      def to_f
        seconds + nanos.quo(1_000_000_000)
      end
    end
  end
end

module Wire
  class Encoder
    using ProtobufRefinements
    include Singleton

    def encode(obj)
      case obj
      when Model::Juice
        encode_juice(obj)
      when Array
        encode_juice_list(obj) if obj.all? { |e| e.is_a?(Model::Juice) }
      else
        raise 'not supported'
      end
    end

    def decode(type, msg)
      raise 'unknown type' unless type == :juice
      juice_pb = Wire::Juice.decode(msg)
      Model::Juice.new(
        id: juice_pb.id,
        name: juice_pb.name,
        created_at: juice_pb.created_at.to_time,
        updated_at: juice_pb.updated_at.to_time,
        size: juice_pb.size
      )
    end

    private

    def encode_juice(obj)
      Wire::Juice.encode(build_wire_juice_msg(obj))
    end

    def encode_juice_list(ary)
      msg = Wire::JuiceList.new(juices: ary.map { |e| build_wire_juice_msg(e) })
      Wire::JuiceList.encode(msg)
    end

    def build_wire_juice_msg(obj)
      Wire::Juice.new(id: obj.id,
                      name: obj.name,
                      created_at: obj.created_at.to_protobuf,
                      updated_at: obj.updated_at.to_protobuf,
                      size: obj.size)
    end
  end

  def self.encode(*args)
    Encoder.instance.encode(*args)
  end

  def self.decode(*args)
    Encoder.instance.decode(*args)
  end
end
