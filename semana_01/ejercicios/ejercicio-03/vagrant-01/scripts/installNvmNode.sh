#!/bin/bash

sudo apt install -y wget curl nginx zip unzip

sudo systemctl start nginx
sudo systemctl status nginx

sudo -H -u vagrant bash << EOF
# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# in lieu of restarting the shell
\. "/home/vagrant/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 18

# Verify the Node.js version:
node -v # Should print "v18.20.8".
nvm current # Should print "v18.20.8".

# Verify npm version:
npm -v # Should print "10.8.2".
EOF
sudo -H -u vagrant bash << EOF
wget https://github.com/startbootstrap/startbootstrap-business-casual/archive/gh-pages.zip
sudo unzip -j gh-pages.zip -d /var/www/html
cd /var/www/html
ls -la
EOF
