# prerequsite packages needed by kernel plugins/libaries
if node['jupyterhub']['addons'].attribute?('packages')
  package 'jupyterhub_addon_packages' do
    package_name node['jupyterhub']['addons']['packages']
  end
end

# install jupyterhub python addons
# these pips often require jupyterhub already installed as a prerequsite and
# therefore can not be installed during the initial python pip run(s).
if node['jupyterhub']['addons'].attribute?('pips')
  bash 'jupyterhub_addon_pips' do
    code <<-EOF
      #{node['python']['python3']['bin']} -m pip install #{node['jupyterhub']['addons']['pips'].join(' ')}
    EOF
    environment 'PATH' => "/usr/local/bin:#{ENV['PATH']}"
  end
end

# install jupyter serverextension
if node['jupyterhub']['addons'].attribute?('serverextensions')
  node['jupyterhub']['addons']['serverextensions'].each do |serverextension|
    bash "jupyterhub_addon_serverextension_#{serverextension}" do
      code <<-EOF
        jupyter serverextension enable #{serverextension} --py --sys-prefix
      EOF
      environment 'PATH' => "/usr/local/bin:#{ENV['PATH']}"
    end
  end unless node['jupyterhub']['addons']['serverextensions'].empty?
end

# install jupyter nbextension
if node['jupyterhub']['addons'].attribute?('nbextensions')
  node['jupyterhub']['addons']['nbextensions'].each do |nbextension|
    bash "jupyterhub_addon_nbextension_#{nbextension}" do
      code <<-EOF
        jupyter nbextension install #{nbextension} --py --sys-prefix
        jupyter nbextension enable #{nbextension} --py --sys-prefix
      EOF
      environment 'PATH' => "/usr/local/bin:#{ENV['PATH']}"
    end
  end unless node['jupyterhub']['addons']['nbextensions'].empty?
end
