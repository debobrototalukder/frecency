module Frecency
  class Configuration
    attr_accessor :default_frequency_column, :default_recency_column, :default_custom_frequency_scope

    def initialize
      @default_frequency_column = :views
      @default_recency_column = :updated_at
      @default_custom_frequency_scope = nil
    end
  end
end
