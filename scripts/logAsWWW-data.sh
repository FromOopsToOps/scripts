#!/bin/bash

echo "/var/log/apache2/*.log {
    postrotate
        /usr/bin/setfacl -m g:www-data:rx /var/log/apache2
    endscript
}
" > /etc/logrotate.d/apache-logs

echo "/var/log/nginx/*.log {
    postrotate
	/usr/bin/setfacl -m g:www-data:rx /var/log/nginx
    endscript
}
" > /etc/logrotate.d/nginx-logs
