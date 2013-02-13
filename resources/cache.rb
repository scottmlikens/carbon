actions :create, :start, :stop

# No Dependency checking here, this obviously will not be true on distros that do not run 2.7
attribute :cookbook, :kind_of => String, :default => "carbon"
attribute :storage_aggregation, :kind_of => Hash, :default => {}
attribute :python_interpreter, :kind_of => String, :default => "python2.7"
attribute :carbon_template_source, :kind_of => String, :default => "carbon.conf.erb"
attribute :storage_template_source, :kind_of => String, :default => "storage-schemas.conf.erb"
attribute :cpu_affinity
attribute :options, :kind_of => Hash
attribute :user, :kind_of => String, :default => "graphite"
attribute :group, :kind_of => String, :default => "graphite"
attribute :max_cache_size, :kind_of => String, :default => "inf"
attribute :max_updates_per_second, :kind_of => Fixnum, :default => 5000
attribute :max_creates_per_minute, :kind_of => Fixnum, :default => 100
attribute :line_listner, :kind_of => Hash, :default => {"line_receiver_interface" => "0.0.0.0", "line_receiver_port" => 2003 }
attribute :pickle_listner, :kind_of => Hash, :default => {"pickle_receiver_interface" => "0.0.0.0", "pickle_receiver_port" => 2004 }
attribute :udp_listner, :kind_of => Hash, :default => {"enable_udp_listner" => "False", "udp_receiver_interface" => "0.0.0.0", "udp_receiver_port" => 2003 }
attribute :use_insecure_pickler, :kind_of => String, :default => "False"
attribute :use_flow_control, :kind_of => String, :default => "True"
attribute :cache_query, :kind_of => Hash, :default => {"cache_query_interface" => "0.0.0.0", "cache_query_port" => 7002 }
attribute :log_updates, :kind_of => String, :default => "False"
attribute :whisper_autoflush, :kind_of => String, :default => "False"
attribute :enable_amqp, :kind_of => String, :default => "False"
attribute :amqp_verbose, :kind_of => String, :default => "False"
attribute :amqp, :kind_of => Hash, :default => {"amqp_host" => "localhost", "amqp_port" => 5672, "amqp_vhost" => "/", "amqp_user" => "guest", "amqp_password" => "guest", "amqp_exchange" => "graphite", "amqp_metric_name_in_body" => "False" }
attribute :bind_patterns, :kind_of => Array, :default => ["#"]
attribute :graphite_home, :kind_of => String, :default => "/opt/graphite"
attribute :carbon_packages, :kind_of => Hash, :default => { "whisper" => "0.9.10", "carbon" => "0.9.10" }
attribute :carbon_instance, :kind_of => String, :default => "a"
attribute :storage_schema, :kind_of => Hash, :default => { :all => { :pattern => "(.*)", :retentions => "10s:90d, 60s:1y" } }
attribute :local_data_dir, :kind_of => String, :default => "/opt/graphite/storage/whisper"
attribute :init_style, :kind_of => String, :default => "runit"

def initialize(*args)
  super
  @action = :install
  @run_context.include_recipe ["build-essential","python","python::pip","python::virtualenv","runit::default"]
end
