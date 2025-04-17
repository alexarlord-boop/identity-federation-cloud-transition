# Shibboleth Service Provider (SP) Dockerfile
This repository automates a Shibboleth Service Provider (SP).

## Resources

### Installation
https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2065335547/LinuxInstall
https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2065335566/RPMInstall
https://shibboleth.net/downloads/service-provider/RPMS/
https://hub.docker.com/_/rockylinux


Helper and check commands
1. httpd -M | grep shib
1. ps aux | grep httpd
1. apachectl configtest
1. curl -i http://localhost/Shibboleth.sso/Status
1. xmllint --noout /etc/shibboleth/shibboleth2.xml
1. tail -n 50 /var/log/httpd/error_log
1. tail -n 50 /var/log/httpd/access_log
1. tail -f /var/log/shibboleth/shibd.log
1. shibd -f
1. shibd -t

URLs that must work
1. https://localhost/Shibboleth.sso/Metadata
1. https://localhost/Shibboleth.sso/Status


### Configuration
