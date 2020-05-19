# install jupyter
include_recipe "#{cookbook_name}::jupyter_ipykernel"
include_recipe "#{cookbook_name}::jupyter_ipyparallel"
include_recipe "#{cookbook_name}::jupyter_contrib_nbextensions"
