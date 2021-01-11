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
