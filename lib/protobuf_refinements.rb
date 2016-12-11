require "google/protobuf/well_known_types"

module ProtobufRefinements
  refine Time do
    def to_protobuf
      pp Google::Protobuf::Timestamp.new.tap{ |e| e.from_time(utc)}
    end
  end
end
