module OkComputer
  module LegacyRailsControllerSupport
    def self.included(base)
      # Support <callback>_action for Rails 3
      %w(before after around).each do |callback|
        unless base.respond_to?("#{callback}_action")
          base.singleton_class.send(:alias_method, "#{callback}_action", "#{callback}_filter")
        end
      end
    end

    # Support 'render plain' for Rails 3
    def render(*args, &block)
      args = args[0] # Always an options hash
      args[:text] = args.delete(:plain) if args.include?(:plain)
      super(args, block)
    end
  end
end
