# frozen_string_literal: true
require 'google/protobuf/well_known_types'

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

module ProtobufRefinements
  refine Time do
    def to_protobuf
      Google::Protobuf::Timestamp.new.tap { |e| e.from_time(utc) }
    end
  end
end
