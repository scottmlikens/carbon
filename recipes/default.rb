#
# Cookbook Name:: carbon
# Recipe:: default
#
# Copyright 2012, Scott M. Likens
#
#

carbon_cache "sample" do
  action [:install,:config,:start]
  cpu_affinity "2"
end

carbon_relay "sample" do
  action [:config,:start]
end
