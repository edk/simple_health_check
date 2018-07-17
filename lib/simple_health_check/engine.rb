module SimpleHealthCheck
  class Engine < ::Rails::Engine
    isolate_namespace SimpleHealthCheck

    config.after_initialize do |app|
      app.routes.prepend do
        mount SimpleHealthCheck::Engine => SimpleHealthCheck::Configuration.mount_at, as: "healthcheck"
      end
    end
  end
end
