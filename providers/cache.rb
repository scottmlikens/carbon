action :create do
  directory new_resource.graphite_home + "/conf" do
    owner new_resource.user
    group new_resource.group
    action :create
  end
  directory new_resource.graphite_home + "/storage/log" do
    action :create
    owner new_resource.user
    group new_resource.group
    recursive true
  end
  template new_resource.graphite_home + "/conf/carbon-cache-" + new_resource.carbon_instance + ".conf" do
    source new_resource.carbon_template_source
    owner new_resource.user
    group new_resource.group
    cookbook new_resource.cookbook
    mode 0655
    variables(
              :options => new_resource.options,
              :user => new_resource.user,
              :max_cache_size => new_resource.max_cache_size,
              :max_updates_per_second => new_resource.max_updates_per_second,
              :max_creates_per_minute => new_resource.max_creates_per_minute,
              :line_listner => new_resource.line_listner,
              :pickle_listner => new_resource.pickle_listner,
              :udp_listner => new_resource.udp_listner,
              :cache_query => new_resource.cache_query,
              :use_insecure_pickler => new_resource.use_insecure_pickler,
              :use_flow_control => new_resource.use_flow_control,
              :log_updates => new_resource.log_updates,
              :whisper_autoflush => new_resource.whisper_autoflush,
              :enable_amqp => new_resource.enable_amqp,
              :amqp_verbose => new_resource.amqp_verbose,
              :amqp => new_resource.amqp,
              :bind_patterns => new_resource.bind_patterns,
              :local_data_dir => new_resource.local_data_dir
              )
  end
  template new_resource.graphite_home + "/conf/storage-schemas.conf" do
    cookbook new_resource.cookbook
    source new_resource.storage_template_source
    owner new_resource.user
    group new_resource.group
    mode 0655
    variables({
                :schema => new_resource.storage_schema
              })
  end
  template new_resource.graphite_home + "/conf/storage-aggregation.conf" do
    cookbook new_resource.cookbook
    source "storage-aggregation.conf.erb"
    owner new_resource.user
    group new_resource.group
    mode 0655
    variables({
                :storage_aggregation => new_resource.storage_aggregation
              })
  end
  node.set[new_resource.name]=new_resource.to_hash
  new_resource.updated_by_last_action(true)
end
action :start do
  case new_resource.init_style
  when "upstart"
    template "/etc/init/carbon-cache-" + new_resource.carbon_instance + ".conf" do
      cookbook new_resource.cookbook
      source "carbon.init.erb"
      owner "root"
      group "root"
      mode 0644
      variables({
                  :carbon_instance => new_resource.carbon_instance,
                  :graphite_home => new_resource.graphite_home,
                  :user => new_resource.user,
                  :group => new_resource.group,
                  :cpu_affinity => new_resource.cpu_affinity
                })
    end
    service "carbon-cache-" + new_resource.carbon_instance do
      provider Chef::Provider::Service::Upstart
      action [:enable,:start]
    end
  when "runit"
  runit_service "carbon-cache-" + new_resource.carbon_instance do
      cookbook new_resource.cookbook
      run_template_name "carbon-cache"
      default_logger true
      options({
                  :carbon_instance => new_resource.carbon_instance,
                  :graphite_home => new_resource.graphite_home,
                  :user => new_resource.user,
                  :group => new_resource.group,
                  :cpu_affinity => new_resource.cpu_affinity
              })
    end         
  end
  new_resource.updated_by_last_action(true)
end
action :stop do
  case new_resource.init_style
  when "upstart"
    service "carbon-cache-" + new_resource.carbon_instance do
      provider Chef::Provider::Service::Upstart
      action [:stop,:disable]
    end
  when "runit"
    runit_service "stop carbon-cache-" + new_resource.carbon_instance do
      service_name "carbon-cache-" + new_resource.carbon_instance
      action :stop
    end
  else
    log "not supported"
    fatal
  end
  new_resource.updated_by_last_action(true)
end
