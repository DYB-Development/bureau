module Bureau
  class Engine < ::Rails::Engine
    isolate_namespace Bureau

    config.to_prepare do
      Bureau.register_own_sections
    end
  end
end
