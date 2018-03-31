module Finances
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    class << self
      def sql_column column_name
        "`#{table_name}`.`#{column_name}`"
      end
    end

    def sql_column column_name
      send(:class).sql_column column_name
    end

  end
end
