# ===============================================
# Grafana
# ===============================================

node.validate! do
  {
    grafana: {
      version: string,
      https: optional(boolean),
      admin: {
        user: string,
        password: string,
      },
      secret_key: string,
    },
    loki: {
      version: string,
      log_period_days: integer,
    },
  }
end

app_dir = "/usr/local/grafana"

directory app_dir do
  owner "root"
  group "root"
  mode "0755"
end

template "#{app_dir}/docker-compose.yml" do
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[grafana-loki]"
end

log_period_days = node[:loki][:log_period_days].to_i
log_period_hour = log_period_days * 24
retention_period_hour = ((log_period_hour / 168 + 1) * 168).to_i

template "#{app_dir}/loki.yaml" do
  owner "root"
  group "root"
  mode "0644"
  variables(log_period_days: log_period_days, log_period_hour: log_period_hour, retention_period_hour: retention_period_hour)
  notifies :restart, "service[grafana-loki]"
end

remote_file "/etc/systemd/system/grafana-loki.service" do
  owner "root"
  group "root"
  mode "0644"
  notifies :run, "execute[systemctl daemon-reload]", :immediately
end

execute "systemctl daemon-reload" do
  action :nothing
end

service "grafana-loki" do
  action [:start, :enable]
end
