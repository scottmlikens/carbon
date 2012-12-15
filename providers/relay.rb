action :config do
  directory new_resource.graphite_home + "/conf" do
    action :create
    owner new_resource.user
    group new_resource.group
    action :create
  end

  template new_resource.graphite_home + "/conf/carbon-relay-" + new_resource.relay_instance + ".conf" do
    source new_resource.relay_template_source
    owner new_resource.user
    group new_resource.group
    mode 0655
    variables(
              :options => new_resource.options,
              :user => new_resource.user,
              :relay_instance => new_resource.relay_instance,
              :relay_rules => new_resource.relay_rules,
              :relay_method => new_resource.relay_method,
              :replication_factor => new_resource.replication_factor,
              :line_listner => new_resource.line_listner,
              :pickle_listner => new_resource.pickle_listner,
              :relay_method => new_resource.relay_method,
              :replication_factor => new_resource.replication_factor,
              :destinations => new_resource.destinations,
              :max_datapoints_per_message => new_resource.max_datapoints_per_message,
              :max_queue_size => new_resource.max_queue_size,
              :use_flow_control => new_resource.use_flow_control
              )
  end
  template new_resource.graphite_home + "/conf/relay-rules.conf" do
    source new_resource.relay_rules_template_source
    owner  new_resource.user
    group new_resource.group
    mode 0644
    variables({
                :relay_rules => new_resource.relay_rules
              })
  end
  execute "chown -R #{new_resource.user}:#{new_resource.group} #{new_resource.graphite_home}" do
    action :run
  end
  case new_resource.init_style
  when "upstart"
    template "/etc/init/carbon-relay-" + new_resource.relay_instance + ".conf" do
      source new_resource.relay_init_template
      owner "root"
      group "root"
      mode 0644
      variables({
                  :relay_instance => new_resource.relay_instance,
                  :graphite_home => new_resource.graphite_home,
                  :user => new_resource.user,
                  :group => new_resource.group,
                  :cpu_affinity => new_resource.cpu_affinity
                })
    end
  else
    log "not implemented"
    fatal
  end
end
action :start do
  case new_resource.init_style
  when "upstart"
    service "carbon-relay-" + new_resource.relay_instance do
      provider Chef::Provider::Service::Upstart
      action [:enable,:start]
    end
  else
    log "not implemented"
    fatal
  end
end
action :stop do
  case new_resource.init_style
  when "upstart"
    service "carbon-relay-" + new_resource.relay_instance do
      provider Chef::Provider::Service::Upstart
      action [:stop,:disable]
    end
  else
    log "not implemented"
    fatal
  end
end
