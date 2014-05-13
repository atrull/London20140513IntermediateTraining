#
# All Rights Reserved
#

# TODO: Figure out why some of these are +bash+ and some are +execute+.

# http://some-link-on-the-internet.com/tutorial-for-doing-something
execute <<-EOH
apt-get -y install apache2
EOH

# idk what the -p is, but that's what was on the Internet
execute <<-EOH
mkdir -p /var/www/pos
mkdir -p /var/www/pos/public
EOH

# This seems to write out the file every time, but whatevs. It works, and I'm
# not even getting paid to wite this...
bash <<-EOH
cat > /var/www/pos/public/index.html <<EOL
<html>
  <head>ACME Supermarket Terminal #{node['fqdn']}</head>

  <body>
    <p>Placeholder text</p>
  </body>
</html>
EOL
EOH

# Have to remove the default site
bash <<-EOH
# Need the -f or else things go boom when the file does not exist
a2dissite default
EOH

# Borrowed from: http://httpd.apache.org/docs/2.0/vhosts/examples.html#default
execute <<-EOH
cat > /etc/apache2/sites-available/default <<EOL
<VirtualHost _default_:*>
  DocumentRoot /var/www/pos/public
</VirtualHost>
EOL
EOH

# This is only needed on the first run, but I have a party to get to, so I can't
# figure this out now.
bash <<-EOH
service apache2 restart
EOH
