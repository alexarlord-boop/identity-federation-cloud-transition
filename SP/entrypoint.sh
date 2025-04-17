#!/bin/bash
set -e

# Ensure shibboleth socket is clean
rm -f /var/run/shibboleth/shibd.sock

# Start shibd in background
shibd

# Start Apache in foreground
exec /usr/sbin/httpd -D FOREGROUND