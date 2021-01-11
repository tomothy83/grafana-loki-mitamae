# ===============================================
# Timezone
# ===============================================

node.validate! do
  {
    timezone: string,
  }
end

execute "timedatectl set-timezone #{node[:timezone]}" do
  not_if "timedatectl | grep #{node[:timezone]}"
end
