module Finances
  module Constraints
    class MonthConstraint
      def self.matches? request
        request[:month].nil? || request[:month] == 'all' || request[:month] =~ /\d{4}-\d{2}/
      end
    end
  end
end
