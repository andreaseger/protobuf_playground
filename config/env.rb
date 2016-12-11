# frozen_string_literal: true
require 'bundler'
ENV['RACK_ENV'] ||= 'development'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)
$LOAD_PATH.unshift File.join(__dir__, '..', 'lib')
