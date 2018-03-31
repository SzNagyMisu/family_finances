Dir[::Finances::Engine.root.join 'lib/constraints/finances/*.rb'].each { |f| require f }
