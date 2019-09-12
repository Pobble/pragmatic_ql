require 'active_support/core_ext/object'
require "pragmatic_ql/version"
require 'pragmatic_ql/config'
require 'pragmatic_ql/include_model'
require 'pragmatic_ql/params_parser'
require 'pragmatic_ql/pagination'

module PragmaticQL
  def self.include_model(include_string)
    PragmaticQL::ParamsParser.new(include_string: include_string).include_model
  end

  def self.config
    @config ||= PragmaticQL::Config.new
  end
end
