cache_query_port = 7000
line_receiver_port = 2100
pickle_receiver_port = 2200
dst = []
cpq = []
dstplus = []

carbon_install "stable" do
  action :git
end

("a".."b").each do |ci|
  carbon_cache "carbon-cache-" + ci do
    action [:create,:start]
    carbon_instance ci
    init_style "runit"
    line_listner({"line_receiver_interface" => "0.0.0.0", "line_receiver_port" => line_receiver_port })
    pickle_listner({"pickle_receiver_interface" => "0.0.0.0", "pickle_receiver_port" => pickle_receiver_port })
    udp_listner({"enable_udp_listner" => "False", "udp_receiver_interface" => "0.0.0.0", "udp_receiver_port" => line_receiver_port })
    cache_query({"cache_query_interface" => "0.0.0.0", "cache_query_port" => cache_query_port })
    storage_aggregation({:min => { :pattern => "\.min$", :xfilesfactor => "0.1", :aggregationmethod => "min" }, :max => { :pattern => "\.max$", :xfilesfactor => "0.1", :aggregationmethod => "max" }, :sum => { :pattern => "\.count$", :xfilesfactor => "0", :aggregationmethod => "sum" }, :default_average => { :pattern => ".*", :xfilesfactor => "0.5", :aggregationmethod => "average"}})
    cache_query_port+= 1
    line_receiver_port+= 1
    pickle_receiver_port+= 1
    dstplus << "127.0.0.1:#{pickle_receiver_port}:#{ci}"
  end
end


carbon_relay "relay" do
  action [:create,:start]
  relay_rules({ "default" => { "default" => "true", "destinations" => dstplus, "continue" => String.new, "pattern" => String.new } })
  line_listner({"line_receiver_interface" => "0.0.0.0", "line_receiver_port" => 2003 })
  pickle_listner({"pickle_receiver_interface" => "0.0.0.0", "pickle_receiver_port" => 2004 })
  destinations dstplus
  relay_instance "a"
  init_style "runit"
end
