# frozen_string_literal: true
require 'google/protobuf/well_known_types'

module ProtobufRefinements
  refine Time do
    def to_protobuf
      Google::Protobuf::Timestamp.new.tap { |e| e.from_time(utc) }
    end
  end
end
