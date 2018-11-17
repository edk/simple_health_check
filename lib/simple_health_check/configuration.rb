module SimpleHealthCheck
  module Configuration
    class << self
      # options for predefined checks:
      %w[
        generic_check
        http_endpoint_check_proc
        json_file
        mount_at
        mysql_check_proc
        s3_check_proc
        redis_check_proc
        version_file
      ].each do |opt|
        attr_accessor opt.to_sym
      end

      attr_accessor :options

      def all_checks
        @checks ||= [SimpleHealthCheck::BasicStatus]
        @memoized_all_checks ||= @checks.map do |c|
          c.is_a?(Class) ? c.new : c
        end
      end

      def add_check klass_or_instance
        if klass_or_instance.respond_to?(:new)
          self.all_checks << klass_or_instance.new
        else
          self.all_checks << klass_or_instance
        end
      end

      def configure
        yield self if block_given?
        self
      end
    end

    self.mount_at = 'health'
    self.version_file = 'VERSION'
    self.options = {}
  end
end
