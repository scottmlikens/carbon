name "carbon"
maintainer       "Scott M. Likens"
maintainer_email "scott@likens.us"
license          "Apache 2.0"
description      "Installs/Configures carbon"
long_description description
version          "0.0.6"
supports 'ubuntu'
%w{build-essential python runit git carbon}.each do |dp|
  depends dp
end
