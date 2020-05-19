# python2 install packages(s)
if node['python']['python2'].attribute?('packages')
  package 'python2_install_packages' do
    package_name node['python']['python2']['packages']
  end
end

# python2 install easy_install(s)
if node['python']['python2'].attribute?('easy_installs')
  node['python']['python2']['easy_installs'].each do |easy_install|
    bash "python2_easy_install_#{easy_install}" do
      code "#{node['python']['python2']['easy_install_bin']} #{easy_install}"
    end
  end unless node['python']['python2']['easy_installs'].empty?
end

# python2 upgrade tools
bash 'python2_upgrade_tools' do
  code "#{node['python']['python2']['bin']} -m pip install --upgrade pip setuptools wheel"
end

# python2 create symlink(s)
if node['python']['python2'].attribute?('symlinks')
  node['python']['python2']['symlinks'].each do |target, link|
    link "python2_symlink_#{target}_to_#{link}" do
      target_file target
      to link
    end
  end unless node['python']['python2']['symlinks'].empty?
end

# install pips
if node['python']['python2'].attribute?('pips')
  bash 'pyhton3_install_pips' do
    code "#{node['python']['python2']['bin']} -m pip install #{node['python']['python2']['pips'].join(' ')}"
  end unless node['python']['python2']['pips'].empty?
end
