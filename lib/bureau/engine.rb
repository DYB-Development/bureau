module Bureau
  class Engine < ::Rails::Engine
    isolate_namespace Bureau

    config.to_prepare do
      Bureau.prepare!
    end
  end
end
