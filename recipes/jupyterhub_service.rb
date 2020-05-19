bash 'reload_systemd' do
  code 'systemctl daemon-reload'
  action :nothing
end

template '/etc/sysconfig/jupyterhub' do
  source 'jupyterhub_sysconfig.erb'
  path '/etc/sysconfig/jupyterhub'
  owner 'root'
  group 'root'
  mode '644'
  action :create
end

template 'install_jupyterhub_service' do
  source 'jupyterhub.service.erb'
  path '/etc/systemd/system/jupyterhub.service'
  owner 'root'
  group 'root'
  mode '644'
  action :create
  notifies :run, 'bash[reload_systemd]', :immediately
end

service 'start_jupyterhub' do
  service_name 'jupyterhub.service'
  action [:enable, :start]
end
