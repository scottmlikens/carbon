actions :install, :git

# No Dependency checking here, this obviously will not be true on distros that do not run 2.7
attribute :cookbook, :kind_of => String, :default => "carbon"
attribute :python_interpreter, :kind_of => String, :default => "python2.7"
attribute :user, :kind_of => String, :default => "graphite"
attribute :group, :kind_of => String, :default => "graphite"
attribute :graphite_home, :kind_of => String, :default => "/opt/graphite"
attribute :carbon_packages, :kind_of => Hash, :default => { "whisper" => "0.9.10", "carbon" => "0.9.10" }
attribute :carbon_stable_packages, :kind_of => Hash, :default => { "whisper" => "0.9.x", "carbon" => "0.9.x" }
attribute :carbon_stable_base_git_uri, :kind_of => String, :default => "https://github.com/graphite-project/"

def initialize(*args)
  super
  @action = :nothing
  @run_context.include_recipe ["build-essential","python","python::pip","python::virtualenv","git"]
end
