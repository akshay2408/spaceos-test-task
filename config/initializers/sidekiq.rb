if defined?(Sidekiq)
  require "sidekiq/web"
  require "sidekiq/cron/web" if defined?(Sidekiq::Cron)

  # https://github.com/ondrejbartas/sidekiq-cron
  # Sidekiq-cron - It's a very sensible approach to performing scheduled tasks.
  if Sidekiq.server? && defined?(Sidekiq::Cron)
    Rails.application.config.after_initialize do
      schedule_file = Rails.root.join("config/schedule.yml")
      schedule_file_yaml = YAML.load_file(schedule_file) if schedule_file.exist?

      # Use https://crontab.guru to confirm times
      Sidekiq::Cron::Job.load_from_hash(schedule_file_yaml) if schedule_file_yaml
    end
  end

  if defined?(Sidekiq)

    Rails.application.config.cache_store = :redis_cache_store, {
      url: "redis://localhost:6379/",
      network_timeout: 5
    }
  end

  Rails.application.config.active_job.queue_adapter = :sidekiq
end
