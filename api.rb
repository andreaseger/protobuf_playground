# frozen_string_literal: true
require 'use_case/create'
require 'use_case/show'
require 'use_case/index'

require 'wire/types_pb'
class Api < Rack::App
  serializer do |obj|
    case obj
    when Wire::Juice
      Wire::Juice.encode(obj)
    when Wire::JuiceList
      Wire::JuiceList.encode(obj)
    end
  end

  namespace '/juices' do
    desc 'Create'
    post '/' do
      UseCase::Create.new(payload: payload).run
    end

    desc 'Read (show)'
    get '/:id' do
      UseCase::Show.new(id: params['id']).run
    end

    desc 'Read (index)'
    get '/' do
      UseCase::Index.new.run
    end
  end
end
