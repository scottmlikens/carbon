maintainer       "Scott M. Likens"
maintainer_email "scott@likens.us"
license          "Apache 2.0"
description      "Installs/Configures carbon"
long_description description
version          "0.0.4"
%w{build-essential python runit}.each do |dp|
  depends dp
end
