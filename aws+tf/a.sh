apt update
apt install -y apache2
systemctl start apache2
systemctl enable apache2
echo "Hello World" > /var/www/html/index.html
```
