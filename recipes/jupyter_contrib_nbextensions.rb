# enable contrib nbextensions tab in jupyterhub
if node['jupyter']['setup']['enable_contrib_nbextensions']
  bash 'jupyter_enable_contrib_nbextensions' do
    code <<-EOF
      if /bin/grep -qi jupyter-contrib-nbextensions <(python3 -m pip list --format=columns); then
        jupyter contrib nbextension install --system
      fi
      if /bin/grep -qi jupyter-nbextensions-configurator <(python3 -m pip list --format=columns); then
        jupyter nbextensions_configurator enable --system
      fi
    EOF
    environment 'PATH' => "/usr/local/bin:#{ENV['PATH']}"
  end
end
