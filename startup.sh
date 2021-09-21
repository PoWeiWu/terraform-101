#!/bin/bash
sudo yum -y install httpd
sudo systemctl start httpd && sudo systemctl enable httpd
echo '<h1><center>Hello World</center></h1>' > index.html
sudo mv index.html /var/www/html/
sudo setenforce 0
sudo chmod -R 755 /var/www/html/