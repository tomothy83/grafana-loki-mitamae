# ===============================================
# docker and docker-compose
# ===============================================
node.validate! do
  {
    docker: {
      compose_version: string,
    },
  }
end

package "apt-transport-https"
package "ca-certificates"
package "wget"
package "gpg-agent"
package "software-properties-common"

execute "add gpg key" do
  command "wget -qO - https://packages.fluentbit.io/fluentbit.key | apt-key add -"
  not_if "apt-key list | grep treasure-data"
end

execute "add td-agent-bit repository" do
  command <<EOB
    add-apt-repository \
    "deb https://packages.fluentbit.io/ubuntu/bionic bionic main"
EOB
  not_if "grep fluentbit /etc/apt/sources.list"
end

execute "apt update after td-agent-bit repository added" do
  subscribes :run, "execute[add td-agent-bit repository]", :immediately
  action :nothing
end

package "td-agent-bit"

service "td-agent-bit" do
  action [:start, :enable]
end

directory "/usr/lib/td-agent-bit" do
  owner "root"
  group "root"
  mode "0755"
end

remote_file "/usr/lib/td-agent-bit/out_grafana_loki.so" do
  owner "root"
  group "root"
  mode "0644"
end

remote_file "/etc/td-agent-bit/plugins.conf" do
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[td-agent-bit]"
end

remote_file "/etc/td-agent-bit/td-agent-bit.conf" do
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[td-agent-bit]"
end
