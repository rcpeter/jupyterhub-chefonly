# install anaconda
include_recipe "#{cookbook_name}::anaconda_install"
include_recipe "#{cookbook_name}::anaconda_config"
include_recipe "#{cookbook_name}::anaconda_virtualenv"
