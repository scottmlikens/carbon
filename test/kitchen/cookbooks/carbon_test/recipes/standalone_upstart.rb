carbon_install "stable" do
  action :git
end

carbon_cache "carbon-cache" do
  action [:create,:start]
  storage_aggregation({:min => { :pattern => "\.min$", :xfilesfactor => "0.1", :aggregationmethod => "min" }, :max => { :pattern => "\.max$", :xfilesfactor => "0.1", :aggregationmethod => "max" }, :sum => { :pattern => "\.count$", :xfilesfactor => "0", :aggregationmethod => "sum" }, :default_average => { :pattern => ".*", :xfilesfactor => "0.5", :aggregationmethod => "average"}})
  carbon_instance "a"
  init_style "upstart"
  cpu_affinity 0
end

