#!/usr/bin/env bats
@test "/opt/graphite/storage/carbon-cache-a.lock should exist" {
[ -f "/opt/graphite/storage/carbon-cache-a.lock" ]
}
@test "carbon-cache-a is set on cpu 0" {
[ $(taskset -pc `cat /opt/graphite/storage/carbon-cache-a.pid` | cut -d ':' -f 2) == 0 ]
}
@test "carbon-cache-a can accept traffic" {
echo "test.metric 1 `date +%s`"| nc 127.0.0.1 2003;
}
