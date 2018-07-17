module SimpleHealthCheck
  module Configuration
    class << self
      attr_accessor :mount_at
      attr_accessor :version_file
      attr_accessor :options
      attr_accessor :all_checks

      def all_checks
        @memoized_all_checks ||= @all_checks.map do |c|
          c.is_a?(Class) ? c.new : c
        end
      end

      def add_check klass
        @memoized_all_checks = nil
        self.all_checks << klass.new
      end

      def configure
        yield self if block_given?
        self
      end
    end

    self.mount_at = 'health'
    self.version_file = 'VERSION'
    self.options = {}
    self.all_checks = [ SimpleHealthCheck::BasicStatus ]
  end
end
