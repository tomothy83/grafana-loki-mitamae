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
