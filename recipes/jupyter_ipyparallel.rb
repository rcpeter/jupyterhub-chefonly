# enable ipython clusters tab in jupyterhub
if node['jupyter']['setup']['allow_parallel_computing']
  bash 'jupyter_enable_parallel_computing' do
    code <<-EOF
      if /bin/grep -qi ipyparallel <(/bin/pip3 list --format=columns); then
        ipcluster nbextension enable
        jupyter nbextension install --sys-prefix --py ipyparallel
        jupyter nbextension enable --sys-prefix --py ipyparallel
        jupyter serverextension enable --sys-prefix --py ipyparallel
      fi
    EOF
    environment 'PATH' => "/usr/local/bin:#{ENV['PATH']}"
  end
end
