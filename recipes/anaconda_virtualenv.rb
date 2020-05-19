# anaconda create virtualenv(s)
if node['anaconda'].attribute?('virtualenvs')
  node['anaconda']['virtualenvs'].each do |name, params|
    bash "anaconda_create_virtualenv_#{name}" do
      code <<-EOF
        source /etc/profile.d/anaconda.sh
        if [ ! -d #{node['anaconda']['config']['app_dir']}/current/envs/#{name} ]; then
          conda create -n #{name} python=#{params['python']} -y
        fi
        source activate #{name}
        conda install --name #{name} #{params['condas'].join(' ')} -y
        python -m pip install #{params['pips'].join(' ')} -y
        conda deactivate
      EOF
    end
  end unless node['anaconda']['virtualenvs'].empty?
end
