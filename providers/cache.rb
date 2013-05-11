use_inline_resources

action :create do
  %w{conf storage storage/log}.each do |ab|
    directory new_resource.graphite_home + "/" + ab do
      owner new_resource.user
      group new_resource.group
      action :create
      recursive true
    end
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
              :local_data_dir => new_resource.local_data_dir,
              :log_cache_hits => new_resource.log_cache_hits
              )
    notifies :restart, "runit_service[carbon-cache-" + new_resource.carbon_instance + "]",:delayed
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
    notifies :restart, "runit_service[carbon-cache-" + new_resource.carbon_instance + "]",:delayed
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
    notifies :restart, "runit_service[carbon-cache-" + new_resource.carbon_instance + "]",:delayed
  end
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
  node.set[new_resource.name]=new_resource.to_hash
end
