# frozen_string_literal: true
require 'model/juice'
require 'use_case/create'
require 'use_case/show'
require 'use_case/index'

require 'wire'
class Api < Rack::App
  serializer do |obj|
    Wire.encode(obj)
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
