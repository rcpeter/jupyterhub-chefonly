# install jupyterhub
include_recipe "#{cookbook_name}::jupyterhub_install"
include_recipe "#{cookbook_name}::jupyterhub_config"
include_recipe "#{cookbook_name}::jupyterhub_addons"
include_recipe "#{cookbook_name}::jupyterhub_service"
