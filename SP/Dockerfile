FROM rockylinux:9

RUN dnf -y update && \
    dnf -y install httpd mod_ssl --setopt=install_weak_deps=False && \
    echo "[shibboleth]" > /etc/yum.repos.d/shibboleth.repo && \
    echo "name=Shibboleth SP (RockyLinux 9)" >> /etc/yum.repos.d/shibboleth.repo && \
    echo "baseurl=https://bihs.aco.net/shib/yum/rockylinux9/" >> /etc/yum.repos.d/shibboleth.repo && \
    echo "enabled=1" >> /etc/yum.repos.d/shibboleth.repo && \
    echo "gpgcheck=0" >> /etc/yum.repos.d/shibboleth.repo && \
    dnf -y install shibboleth --nobest && \
    dnf clean all

# Copy configuration files
COPY apache/shib.conf /etc/httpd/conf.d/shib.conf
COPY /shibboleth/shibboleth2.xml /etc/shibboleth/shibboleth2.xml
# COPY /shibboleth/partner-metadata.xml /etc/shibboleth/partner-metadata.xml
COPY /shibboleth/ssl.conf /etc/httpd/conf.d/ssl.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 443

# CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
# # CMD ["httpd", "-DFOREGROUND"]
# # ENTRYPOINT ["shibd-apache2"]

CMD ["/entrypoint.sh"]