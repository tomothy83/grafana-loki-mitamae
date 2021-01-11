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
package "curl"
package "gpg-agent"
package "software-properties-common"

execute "add gpg key" do
  command "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -"
  not_if "apt-key fingerprint 0EBFCD88 | grep docker"
end

execute "add repository" do
  command <<EOB
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
EOB
  not_if "grep docker /etc/apt/sources.list"
end

execute "apt-get update" do
  subscribes :run, "execute[add repository]", :immediately
  action :nothing
end

package "docker-ce"
package "docker-ce-cli"
package "containerd.io"

service "docker" do
  action [:start, :enable]
end

execute "install docker compose" do
  user "root"
  command "curl -L \"https://github.com/docker/compose/releases/download/#{node[:docker][:compose_version]}/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose"
  not_if "/usr/local/bin/docker-compose --version | grep #{node[:docker][:compose_version]}"
end

execute "chmod docker compose" do
  user "root"
  command 'chmod +x /usr/local/bin/docker-compose'
  subscribes :run, "execute[install docker compose]"
  action :nothing
end
