Description
===========

This cookbook provides two resources and providers to install and configure [Graphite](http://graphite.wikidot.com/) *Carbon {Cache:Relay}* under [virtualenv](http://pypi.python.org/pypi/virtualenv).  Currently supported resources:

* Carbon Relay (`relay`)
* Carbon Cache (`cache`)

Requirements
============

1. [Ubuntu](https://ubuntu.com/)
	12.04 Has been tested, other versions may work.
2. [Python](http://github.com/opscode-cookbooks/python/)
  Provides virtualenv support and the pip provider
3. [graphite](http://github.com/damm/graphite/)
  Installs the **Graphite Web** Service to display Metrics stored by *Carbon Cache*

Recipes
============

default.rb
----------

The default recipe does absolutely nothing.  It is not intended to do anything 

Resources and Providers
=======================

This cookbook provides two resource and corresponding providers.

`install.rb`
-------------

Installs [Carbon Cache](https://github.com/graphite-project/carbon) from either [Pypi](http://pypi.python.org/pypi/carbon) or [Github](https://github.com/graphite-project/carbon)

Actions:

* `install` - installs carbon-cache from Pypi
* `git` - installs carbon-cache via *git*

Attribute Parameters:

* `carbon_stable_base_git_uri` - String - default - `https://github.com/graphite-project/`
* `carbon_stable_packages` - Hash - default - `{ "whisper" => "0.9.x", "carbon" => "0.9.x" }`
* `graphite_home` - String - default - `/opt/graphite`
* `user` - String - default - `graphite`
* `carbon_packages` - Hash - `{ "whisper" => "0.9.10", "carbon" => "0.9.10" }`

`cache.rb`
-------------

Installs and Configures [Carbon Cache](https://github.com/graphite-project/carbon) from

Actions:

* `create` - configures carbon-cache
* `start` - starts carbon-cache
* `stop` - stops carbon-cache

Attribute Parameters:

* `cookbook` - String - default - `carbon` - cookbook to fetch *all* templates from
* `python_interpreter` - String - default - `python2.7`
* `carbon_template_source` - String - default - `carbon.conf.erb`
* `storage_template_source` - String -  default - `storage-schemas.conf.erb`
* `cpu_affinity` - String
* `options` - Hash
* `user` - String - default - `graphite`
* `group` - String - default - `graphite`
* `max_cache_size` - String - default - `inf`
* `max_updates_per_second` - Fixnum - default - `5000`
* `max_creates_per_minute` - Fixnum - default - `100`
* `line_listner` - Hash - default - `{"line_receiver_interface" => "0.0.0.0", "line_receiver_port" => 2003 }`
* `pickle_listner` - Hash - default - `{"pickle_receiver_interface" => "0.0.0.0", "pickle_receiver_port" => 2004 }`
* `udp_listner` - Hash - default - `{"enable_udp_listner" => "False", "udp_receiver_interface" => "0.0.0.0", "udp_receiver_port" => 2003 }`
* `use_insecure_pickler` - String - default - `False`
* `use_flow_control` - String - default - `True`
* `cache_query` - Hash -  default - `{"cache_query_interface" => "0.0.0.0", "cache_query_port" => 7002 }`
* `log_updates` - String - default - `False`
* `whisper_autoflush` - String -  default - `False`
* `enable_amqp` - String -  default - `False`
* `amqp_verbose` - String -  default - `False`
* `amqp` - Hash - default - `{"amqp_host" => "localhost", "amqp_port" => 5672, "amqp_vhost" => "/", "amqp_user" => "guest", "amqp_password" => "guest", "amqp_exchange" => "graphite", "amqp_metric_name_in_body" => "False" }`
* `bind_patterns` - Array -  default - `"#"`
* `graphite_home` - String - default - `/opt/graphite`
* `carbon_packages` - Hash -  default - `{ "whisper" => "0.9.10", "carbon" => "0.9.10" }`
* `carbon_instance` - String -  default - `a`
* `storage_schema` - Hash - default - `{ :all => { :pattern => "(.*)", :retentions => "10s:90d, 60s:1y" } }`
* `storage_aggregation` - Hash - default - `{ }`
* `local_data_dir` - String - default - `/opt/graphite/storage/whisper`
* `init_style` - String - default - `runit`

`relay.rb`
-------------

Configures [Carbon Relay](https://github.com/graphite-project/carbon)


Actions:

* `create` - configures carbon-relay
* `start` - starts carbon-relay
* `stop` - stops carbon-relay
* `disable` - disables carbon-relay

Attribute Parameters:

* `cookbook` -  String - `carbon` - name of the cookbook to get templates from
* `options` -  Hash 
* `relay_rules` -  Hash - default - `{"default" => { "default" => "true"' - "destinations" => ["127.0.0.1:2004"]' - "continue" => "false"' - "pattern" => String.new } }`
* `line_listner` -  Hash - default - `{"line_receiver_interface" => "0.0.0.0"' - "line_receiver_port" => 2013 }`
* `pickle_listner` -  Hash - default `{"pickle_receiver_interface" => "0.0.0.0"' - "pickle_receiver_port" => 2014 }`
* `relay_method` -  String - default - `consistent-hashing` 
* `replication_factor` -  Fixnum - default - `1`
* `destinations` -  Array' - default - `["127.0.0.1:2004:a"]`
* `max_datapoints_per_message` -  Fixnum - default `500`
* `max_queue_size` -  Fixnum - default - `10000`
* `use_flow_control` -  String - default - `True`
* `graphite_home` -  String - default - `/opt/graphite` - location to install graphite to
* `relay_instance` -  String - default - `a` 
* `user` - String - default - `graphite` - username to install graphite under
* `group` - String - default -  `graphite` - group to install graphite under
* `python_interpreter` -  String - default - `python2.7`
* `relay_template_source` -  String - default - `carbon-relay.conf.erb`
* `relay_init_template` -  String - default - `carbon-relay.init.erb`
* `init_style` -  String' - default - `runit` 
* `cpu_affinity` -  String - Specifies which cpu to bind the carbon-relay process to
* `relay_rules_template_source` -  String - default - `relay-rules.conf.erb`

Usage
==================

This is the most basic example you are not limited by this example.

```cd chef-repo/cookbooks```  
```git submodule add git://github.com/damm/carbon.git```  
```git submodule add git://github.com/damm/graphite.git```  
```COOKBOOK=graphite_infra rake new_cookbook```  

* The cookbook named ``graphite_infra`` must depend on the *carbon* cookbook.

    carbon_cache "my_carbon" do
      action [:install,:config,:start]  
      cpu_affinity "1"  
    end  
    carbon_relay "sample" do  
      action [:config,:start]    
    end

* For better examples please review our [Tests](https://github.com/damm/carbon/tree/development/test/kitchen/cookbooks/carbon_test/recipes)

License and Author
==================

Author:: Scott M. Likens <scott@spam.likens.us>


Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
  
