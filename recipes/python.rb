# install anaconda
include_recipe "#{cookbook_name}::python_python2"
include_recipe "#{cookbook_name}::python_python3"
include_recipe "#{cookbook_name}::python_virtualenv"
