FROM rockylinux:9

RUN dnf -y update && \
    dnf -y install httpd mod_ssl wget --setopt=install_weak_deps=False && \
    echo "[shibboleth]" > /etc/yum.repos.d/shibboleth.repo && \
    echo "name=Shibboleth SP (RockyLinux 9)" >> /etc/yum.repos.d/shibboleth.repo && \
    echo "baseurl=https://bihs.aco.net/shib/yum/rockylinux9/" >> /etc/yum.repos.d/shibboleth.repo && \
    echo "enabled=1" >> /etc/yum.repos.d/shibboleth.repo && \
    echo "gpgcheck=0" >> /etc/yum.repos.d/shibboleth.repo && \
    dnf -y install shibboleth --nobest && \
    dnf clean all

# Create secure directory for shibboleth
RUN mkdir -p /var/www/html/sp.localtest.me/secure
RUN wget https://raw.githubusercontent.com/GEANT/edugain-training/main/UbuntuNet-Training-202401/config-files/shibboleth/SP3/secure/index.php.txt -O /var/www/html/sp.localtest.me/secure/index.php

# Copy configuration files
COPY apache/shib.conf /etc/httpd/conf.d/shib.conf
COPY /shibboleth/shibboleth2.xml /etc/shibboleth/shibboleth2.xml
COPY /shibboleth/attribute-map.xml /etc/shibboleth/attribute-map.xml
COPY /metadata/idp-metadata.xml /etc/shibboleth/idp-metadata.xml
COPY /shibboleth/ssl.conf /etc/httpd/conf.d/ssl.conf

RUN chown -R shibd:shibd /etc/shibboleth/
RUN chown -R shibd:shibd /var/cache/shibboleth/

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 443

# CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
# # CMD ["httpd", "-DFOREGROUND"]
# # ENTRYPOINT ["shibd-apache2"]

CMD ["/entrypoint.sh"]