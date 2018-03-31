module AdditionalQueriesMatcher

  def make_additional_queries_for &command
    AdditionalQueries.new command
  end
  alias_method :trigger_additional_queries_for, :make_additional_queries_for

  class AdditionalQueries
    attr_reader :command

    def initialize command
      @command = command || raise(ArgumentError, 'block missing')
    end


    def failure_message
    end

    def failure_message_when_negated
    end

    def description
    end


    def matches? subject
      subject.load
      # expect(ActiveRecord::Base.connection).to receive :exec_query
      subscription = ActiveSupport::Notifications.subscribe 'sql.actve_record' do |name, start, finish, id, payload|
        # x + 1
      end
      subject.instance_exec &command
      ActiveSupport::Notifications.unsubscribe subscription # TODO megnézni a rails-controller-testing gemben
    end

    # def does_not_match? subject
    # end

  end

end
