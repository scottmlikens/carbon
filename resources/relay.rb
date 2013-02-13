actions :create, :start, :stop, :disable

attribute :cookbook, :kind_of => String, :default => "carbon"
attribute :options, :kind_of => Hash
attribute :relay_rules, :kind_of => Hash, :default => { "default" => { "default" => "true", "destinations" => ["127.0.0.1:2004"], "continue" => "false", "pattern" => String.new } }
attribute :line_listner, :kind_of => Hash, :default => {"line_receiver_interface" => "0.0.0.0", "line_receiver_port" => 2013 }
attribute :pickle_listner, :kind_of => Hash, :default => {"pickle_receiver_interface" => "0.0.0.0", "pickle_receiver_port" => 2014 }
attribute :relay_method, :kind_of => String, :default => "consistent-hashing"
attribute :replication_factor, :kind_of => Fixnum, :default => 1
attribute :destinations, :kind_of => Array, :default => ["127.0.0.1:2004:a"]
attribute :max_datapoints_per_message, :kind_of => Fixnum, :default => 500
attribute :max_queue_size, :kind_of => Fixnum, :default => 10000
attribute :use_flow_control, :kind_of => String, :default => "True"
attribute :graphite_home, :kind_of => String, :default => "/opt/graphite"
attribute :relay_instance, :kind_of => String, :default => "a"
attribute :user, :kind_of => String, :default => "graphite"
attribute :group, :kind_of => String, :default => "graphite"
attribute :python_interpreter, :kind_of => String, :default => "python2.7"
attribute :relay_template_source, :kind_of => String, :default => "carbon-relay.conf.erb"
attribute :relay_init_template, :kind_of => String, :default => "carbon-relay.init.erb"
attribute :init_style, :kind_of => String, :default => "runit"
attribute :cpu_affinity
attribute :relay_rules_template_source, :kind_of => String, :default => "relay-rules.conf.erb"

def initialize(*args)
  super
  @action = :nothing
end
