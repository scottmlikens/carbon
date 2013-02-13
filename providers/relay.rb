action :create do
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
    cookbook new_resource.cookbook
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
    cookbook new_resource.cookbook
    mode 0644
    variables({
                :relay_rules => new_resource.relay_rules
              })
  end
  node.set[new_resource.name]=new_resource.to_hash
  new_resource.updated_by_last_action(true)
end
action :start do
  case new_resource.init_style
  when "upstart"
  template "/etc/init/carbon-relay-" + new_resource.relay_instance + ".conf" do
      source new_resource.relay_init_template
      owner "root"
      group "root"
      cookbook new_resource.cookbook
      mode 0644
      variables({
                  :relay_instance => new_resource.relay_instance,
                  :graphite_home => new_resource.graphite_home,
                  :user => new_resource.user,
                  :group => new_resource.group,
                  :cpu_affinity => new_resource.cpu_affinity
                })
    end
    service "carbon-relay-" + new_resource.relay_instance do
      provider Chef::Provider::Service::Upstart
      action [:enable,:start]
    end
    when "runit"
    runit_service "carbon-relay-" + new_resource.relay_instance  do
      cookbook new_resource.cookbook
      run_template_name "carbon-relay"
      default_logger true
      options({
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
  new_resource.updated_by_last_action(true)
end
action :stop do
  case new_resource.init_style
  when "upstart"
    service "carbon-relay-" + new_resource.relay_instance do
      provider Chef::Provider::Service::Upstart
      action [:stop,:disable]
    end
  when "runit"
    runit_service "stop carbon-relay-" + new_resource.relay_instance do
      service_name "carbon-relay-" + new_resource.relay_instance
      action :stop
    end
  else
    log "not implemented"
    fatal
  end
  new_resource.updated_by_last_action(true)
end
