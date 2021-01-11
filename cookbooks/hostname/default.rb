# ===============================================
# Hostname
# ===============================================

node.validate! do
  {
    hostname: string,
  }
end

execute "set hostname" do
  command "hostnamectl set-hostname #{node[:hostname]}"
  not_if "test $(hostname) = \"#{node[:hostname]}\""
  notifies :run, "execute[apt-get update]", :immediately
end

execute "apt-get update" do
  action :nothing
  user "root"
end
