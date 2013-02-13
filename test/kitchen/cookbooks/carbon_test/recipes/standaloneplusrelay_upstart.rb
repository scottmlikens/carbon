carbon_install "stable" do
  action :git
end

carbon_cache "carbon-cache-a" do
  action :create
  storage_aggregation({:min => { :pattern => "\.min$", :xfilesfactor => "0.1", :aggregationmethod => "min" }, :max => { :pattern => "\.max$", :xfilesfactor => "0.1", :aggregationmethod => "max" }, :sum => { :pattern => "\.count$", :xfilesfactor => "0", :aggregationmethod => "sum" }, :default_average => { :pattern => ".*", :xfilesfactor => "0.5", :aggregationmethod => "average"}})
end

carbon_cache "carbon-cache" do
  action :start
  init_style "upstart"
  cpu_affinity 1
end

carbon_relay "relay" do
  action :create
end

carbon_relay "carbon-relay" do
  action :start
  init_style "upstart"
  cpu_affinity 0
end
