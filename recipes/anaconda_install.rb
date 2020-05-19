# create anaconda root app_dir
directory "create_#{node['anaconda']['config']['app_dir']}" do
  path node['anaconda']['config']['app_dir']
end

# create anaconda root app_dir
directory "create_#{node['anaconda']['config']['app_dir']}/downloads" do
  path "#{node['anaconda']['config']['app_dir']}/downloads"
end

# install anaconda
bash 'install_anaconda' do
  code "bash #{node['anaconda']['config']['app_dir']}/downloads/#{node['anaconda']['version']}-Linux-x86_64.sh -b -p #{node['anaconda']['config']['app_dir']}/#{node['anaconda']['version']}"
  only_if { ::File.exist?("#{node['anaconda']['config']['app_dir']}/downloads/#{node['anaconda']['version']}-Linux-x86_64.sh") }
  action :nothing
end

# symlink anaconda
link "symlink_#{node['anaconda']['config']['app_dir']}/current" do
  target_file "#{node['anaconda']['config']['app_dir']}/current"
  to "#{node['anaconda']['config']['app_dir']}/#{node['anaconda']['version']}"
  action :nothing
end

# create anaconda profile script
template 'create_anaconda_profile' do
  source 'anaconda.sh.erb'
  path '/etc/profile.d/anaconda.sh'
  owner 'root'
  group 'root'
  mode '644'
  action :create
end

# set anaconda envs
# link 'set_anaconda_envs' do
#   target_file '/etc/profile.d/conda.sh'
#   to "#{node['anaconda']['config']['app_dir']}/current/etc/profile.d/conda.sh"
#   action :nothing
# end

anaconda_source = -> { node['anaconda']['source'][node['anaconda']['version']]['url'] }
anaconda_checksum = -> { node['anaconda']['source'][node['anaconda']['version']]['checksum'] }

# download anaconda
remote_file 'download_anaconda' do
  path "#{node['anaconda']['config']['app_dir']}/downloads/#{node['anaconda']['version']}-Linux-x86_64.sh"
  source anaconda_source.call
  checksum anaconda_checksum.call
  mode '0755'
  action :create_if_missing
  notifies :run, 'bash[install_anaconda]', :immediately
  notifies :create, "link[symlink_#{node['anaconda']['config']['app_dir']}/current]", :immediately
  notifies :create, 'template[create_anaconda_profile]', :immediately
end
