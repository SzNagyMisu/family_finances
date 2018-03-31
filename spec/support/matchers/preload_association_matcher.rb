module PreloadAssociationMatcher

  def preload_associations_for *association_names
    PreloadAssociationsFor.new  association_names
  end

  class PreloadAssociationsFor
    attr_reader :association_names

    def initialize association_names
      @association_names = association_names
    end


    def failure_message
    end

    def failure_message_when_negated
    end

    def description
    end


    def matches? subject
      subject.load
      expect(ActiveRecord::Base.connection).not_to receive :exec_query
      association_names.each do |association_name|
        subject.send association_name
      end
    end

    def does_not_match? subject
    end

  end

end
