# install virtualenv
bash 'python_pip_install_virtualenv' do
  code 'python -m pip install --upgrade virtualenv'
end unless node['python']['virtualenvs'].empty?

# create virtualenv(s)
node['python']['virtualenvs'].each do |name, config|
  directory "virtualenv_#{name}_#{config['dest_dir']}" do
    path config['dest_dir']
    recursive true
    action :create
  end

  bash "virtualenv_create_#{name}" do
    code <<-EOH
        if [ ! -d #{config['dest_dir']}/#{name}/bin ]; then
          virtualenv -p #{config['python']} #{config['dest_dir']}/#{name}
        fi
        source #{config['dest_dir']}/#{name}/bin/activate
        python -m pip install #{config['pips'].join(' ')}
        deactivate
    EOH
  end
end
