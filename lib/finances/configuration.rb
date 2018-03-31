module Finances

  def self.config
    Thread.current[:finances_config] ||= Configuration.new
  end

  def self.configure **options
    if block_given?
      yield config
    else
      options.each do |name, value|
        config.send :"#{name}=", value
      end
    end
  end


  private

    class Configuration
      CONFIGURABLES = %i[ menu_object ]

      attr_accessor *CONFIGURABLES

      def inspect
        config_values = CONFIGURABLES.map { |method, value| " #{method}: #{value.inspect}" }.join(',')
        inspected = super
        inspected[-2] += config_values
        inspected
      end
    end
end
