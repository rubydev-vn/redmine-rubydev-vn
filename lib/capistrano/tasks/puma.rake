# frozen_string_literal: true

namespace :puma do
  desc "Restart Puma"
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, "redmine-puma-production.service"
    end
  end
end
