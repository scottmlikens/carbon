maintainer       "Scott M. Likens"
maintainer_email "scott@likens.us"
license          "Apache 2.0"
description      "Installs/Configures carbon"
long_description description
version          "0.1.0"
%w{build-essential python}.each do |dp|
  depends dp
end
