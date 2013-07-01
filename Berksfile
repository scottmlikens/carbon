site :opscode

metadata

cookbook "build-essential"
cookbook "runit", "1.1.0"
cookbook "git"

group :integration do
  cookbook "apt"
  cookbook "yum"
  cookbook "minitest-handler"
  cookbook "carbon_test", path: "test/cookbooks/carbon_test"
end
