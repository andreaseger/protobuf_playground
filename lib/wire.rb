require "wire/types_pb"
require "protobuf_refinements"

module Wire
  using ProtobufRefinements

  def encode(obj)
    raise "not supported" unless obj.is_a?(Model::Juice)
    Wire::Juice.encode(
      Wire::Juice.new(id: obj.id,
                      name: obj.name,
                      created_at: obj.created_at.to_protobuf,
                      updated_at: obj.updated_at.to_protobuf,
                      size: obj.size)
    )
  end
  module_function :encode

  def decode(type, msg)
    raise "unknown type" unless type == :juice
    juice_pb = Wire::Juice.decode(msg)
    Model::Juice.new(
      id: juice_pb.id,
      name: juice_pb.name,
      created_at: juice_pb.created_at.to_time,
      updated_at: juice_pb.updated_at.to_time,
      size: juice_pb.size
    )
  end
  module_function :decode
end
