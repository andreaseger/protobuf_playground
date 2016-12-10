# frozen_string_literal: true
require 'use_cases/create'
require 'use_cases/show'
require 'use_cases/index'
require 'use_cases/update'
require 'use_cases/delete'

class Api < Rack::App
  namespace '/juices' do
    desc 'Create'
    post '/' do
      "create #{payload}"
    end

    desc 'Read (index)'
    get '/' do
      'index'
    end

    desc 'Read (show)'
    get '/:id' do
      "show #{params['id']}"
    end

    desc 'Update'
    patch '/:id' do
      "update #{params['id']}, #{payload}"
    end

    desc 'Delete'
    delete '/:id' do
      "delete #{params['id']}"
    end
  end
end
