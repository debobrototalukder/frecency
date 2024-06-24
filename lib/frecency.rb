require "frecency/version"
require "frecency/configuration"
require "frecency/frecency_methods"
require "active_support"

module Frecency
  class Error < StandardError; end

  # Initialize configuration
  @configuration = Frecency::Configuration.new

  def self.configure
    yield(@configuration)
  end

  def self.configuration
    @configuration
  end
end

ActiveSupport.on_load(:active_record) do
  include Frecency::FrecencyMethods
end
