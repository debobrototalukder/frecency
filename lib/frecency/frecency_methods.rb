module Frecency
  module FrecencyMethods
    extend ActiveSupport::Concern

    included do
      class_attribute :frecency_frequency_column, instance_accessor: false, default: Frecency.configuration.default_frequency_column
      class_attribute :frecency_recency_column, instance_accessor: false, default: Frecency.configuration.default_recency_column
      class_attribute :frecency_custom_frequency_scope, instance_accessor: false, default: Frecency.configuration.default_custom_frequency_scope
    end

    class_methods do
      def configure_frecency(frequency: nil, recency: nil, custom_frequency_scope: nil)
        self.frecency_frequency_column = frequency || Frecency.configuration.default_frequency_column
        self.frecency_recency_column = recency || Frecency.configuration.default_recency_column
        self.frecency_custom_frequency_scope = custom_frequency_scope || Frecency.configuration.default_custom_frequency_scope
      end

      def frecency(limit = 10)
        frequency_column = frecency_frequency_column
        recency_column = frecency_recency_column
        custom_frequency_scope = frecency_custom_frequency_scope

        if custom_frequency_scope
          scope = custom_frequency_scope.call
          frequency_column = "frequency"
        else
          scope = where.not("#{recency_column}" => nil).where.not("#{frequency_column}" => nil)
        end 

        # Example frecency query, modify based on your database (PostgreSQL example)
        scope
          .select("#{table_name}.*, 
                  ((log(#{frequency_column} + 1) * 100) + 
                  (extract(epoch from age(current_timestamp, #{recency_column})) / 86400)) AS frecency_score")
          .order('frecency_score DESC')
          .limit(limit)
      end
    end
  end
end
