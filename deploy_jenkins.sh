#!/usr/bin/env bash
set -e # halt script on error


echo "Ready to deploy updated version of feideconnect.no"


. ~/cf-login.sh
cf target -o system -s prod

gem install jekyll
gem install rouge

npm install
node_modules/bower/bin/bower install --config.interactive=false -p
node_modules/grunt-cli/bin/grunt publish

cf map-route saml2int saml2int.org

echo "Done."

