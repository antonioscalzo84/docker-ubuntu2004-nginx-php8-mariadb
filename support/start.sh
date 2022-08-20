#!/bin/sh
umask 0000
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf