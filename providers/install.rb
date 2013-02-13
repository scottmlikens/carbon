action :install do
  group new_resource.group do
    action :create
  end
  user new_resource.user do
    group new_resource.group
    shell "/bin/bash"
    home new_resource.graphite_home
    supports :manage_home => true
  end
  directory new_resource.graphite_home do
    owner new_resource.user
    group new_resource.group
    mode 0755
    recursive true
    action :create
  end
  python_virtualenv new_resource.graphite_home do
#    interpreter new_resource.python_interpreter
    owner new_resource.user
    group new_resource.group
    action :create
  end
  package "util-linux"
  carbon_pkgs = new_resource.carbon_packages.collect do |pkg,ver|
    python_pip pkg do
      version ver
      virtualenv new_resource.graphite_home
      user new_resource.user
      action :install
    end
  end
  python_pip "Twisted" do
    version "11.1.0"
    action :install
    user new_resource.user
    virtualenv new_resource.graphite_home
  end
  new_resource.updated_by_last_action(true)
end
action :git do
  group new_resource.group do
    action :create
  end
  user new_resource.user do
    group new_resource.group
    shell "/bin/bash"
    home new_resource.graphite_home
    supports :manage_home => true
  end
  directory new_resource.graphite_home do
    owner new_resource.user
    group new_resource.group
    mode 0755
    recursive true
    action :create
  end
  python_virtualenv new_resource.graphite_home do
#    interpreter new_resource.python_interpreter
    owner new_resource.user
    group new_resource.group
    action :create
  end
  package "util-linux"
  carbon_stable_pkgs = new_resource.carbon_stable_packages.collect do |pkg,ver|
    git "/var/tmp/#{pkg}" do
      user new_resource.user
      repository new_resource.carbon_stable_base_git_uri + pkg + ".git"
      reference ver
      action :checkout
    end
    file "/opt/graphite/.#{pkg}" do
      action :nothing
    end
    script "install #{pkg} in virtualenv #{new_resource.graphite_home}" do
      user new_resource.user
      cwd "/var/tmp/#{pkg}"
      interpreter "bash"
            environment("VIRTUAL_ENV" => new_resource.graphite_home,
                        "PATH" => new_resource.graphite_home + "/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin")
      code <<-EOH
      python setup.py install
      EOH
      notifies :touch, "file[/opt/graphite/." + pkg + "]",:immediately
      not_if { ::File.exists?("/opt/graphite/.#{pkg}") }
    end
  end
  python_pip "Twisted" do
    version "11.1.0"
    action :install
    user new_resource.user
    virtualenv new_resource.graphite_home
  end
  new_resource.updated_by_last_action(true)
end
