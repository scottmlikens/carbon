#!/usr/bin/env bats
@test "/opt/graphite/storage/carbon-cache-a.lock should exist" {
[ -f "/opt/graphite/storage/carbon-cache-a.lock" ]
}
@test "/opt/graphite/storage/carbon-relay-a.lock should exist" {
[ -f "/opt/graphite/storage/carbon-relay-a.lock" ]
}
@test "carbon-relay-a can accept traffic" {
echo "test.metric 1 `date +%s`"| nc 127.0.0.1 2003;
}
