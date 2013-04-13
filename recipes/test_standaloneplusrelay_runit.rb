carbon_install "stable" do
  action :git
end

carbon_cache "carbon-cache-a" do
  action :create
  cpu_affinity 1
  init_style "runit"
  storage_aggregation({:min => { :pattern => "\.min$", :xfilesfactor => "0.1", :aggregationmethod => "min" }, :max => { :pattern => "\.max$", :xfilesfactor => "0.1", :aggregationmethod => "max" }, :sum => { :pattern => "\.count$", :xfilesfactor => "0", :aggregationmethod => "sum" }, :default_average => { :pattern => ".*", :xfilesfactor => "0.5", :aggregationmethod => "average"}})
end

carbon_relay "carbon-relay-a" do
  cpu_affinity 0
  init_style "runit"
  action :create
end

