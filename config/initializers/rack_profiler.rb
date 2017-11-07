if Rails.env.development?
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
  # require "rack-mini-profiler"

  # # initialization is skipped so trigger it
  # Rack::MiniProfilerRails.initialize!(Rails.application)
end
