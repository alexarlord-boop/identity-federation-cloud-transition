# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive \
    LDAP_DOMAIN=example.org \
    BASE_DN=dc=example,dc=org \
    LDAP_ORGANIZATION="Example Org" \
    LDAP_ROOT_PW=ciaoldap \
    LDAP_IDPUSER_PW=idpuserpass \
    LDAP_HOSTNAME=ldap.example.org

#### INSTALLATION

# (1,2,4) Install required packages
RUN apt-get update && apt-get install -y \
    slapd \
    ldap-utils \
    ldapscripts \
    # rsyslog \
    debconf-utils \
    wget \
    vim \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Download schemas
RUN wget https://raw.githubusercontent.com/REFEDS/eduperson/master/schema/openldap/eduperson.ldif -O /etc/ldap/schema/eduperson.ldif && \
    wget https://raw.githubusercontent.com/REFEDS/SCHAC/main/schema/openldap.ldif -O /etc/ldap/schema/schac.ldif


# (3) Configure slapd with debconf
RUN echo "slapd slapd/password1 password $LDAP_ROOT_PW" | debconf-set-selections && \
    echo "slapd slapd/password2 password $LDAP_ROOT_PW" | debconf-set-selections && \
    echo "slapd slapd/move_old_database boolean true" | debconf-set-selections && \
    echo "slapd slapd/domain string $LDAP_DOMAIN" | debconf-set-selections && \
    echo "slapd shared/organization string \"$LDAP_ORGANIZATION\"" | debconf-set-selections && \
    echo "slapd slapd/no_configuration boolean false" | debconf-set-selections && \
    echo "slapd slapd/purge_database boolean false" | debconf-set-selections && \
    echo "slapd slapd/allow_ldap_v2 boolean false" | debconf-set-selections && \
    echo "slapd slapd/backend select MDB" | debconf-set-selections

# Reconfigure slapd with our settings (default admin)
RUN dpkg-reconfigure -f noninteractive slapd

# # Create directories and set permissions
# # RUN mkdir -p /etc/ldap/scratch /var/log/slapd && \
# #     chown syslog /var/log/slapd

# COPY 99-slapd.conf /etc/rsyslog.d/99-slapd.conf


# (6) Generate SSL certificates
RUN openssl req -newkey rsa:4096 -x509 -nodes \
    -out /etc/ldap/$LDAP_HOSTNAME.crt \
    -keyout /etc/ldap/$LDAP_HOSTNAME.key \
    -days 1095 \
    -subj "/CN=$LDAP_HOSTNAME" && \
    chown openldap:openldap /etc/ldap/$LDAP_HOSTNAME.crt && \
    chown openldap:openldap /etc/ldap/$LDAP_HOSTNAME.key

# (7) Configure LDAP SSL settings
RUN sed -i "s/TLS_CACERT.*/TLS_CACERT\t\/etc\/ldap\/$LDAP_HOSTNAME.crt/g" /etc/ldap/ldap.conf && \
    echo -e "TLS_CACERT\t/etc/ldap/$LDAP_HOSTNAME.crt" >> /etc/ldap/ldap.conf && \
    chown openldap:openldap /etc/ldap/ldap.conf

#### CONFIGURATION

# (1) Create scratch directory
RUN mkdir /etc/ldap/scratch

# Copy configuration files
COPY config/* /etc/ldap/scratch
RUN chown -R openldap:openldap /etc/ldap/scratch


# Download schemas (for configuration step 7)
RUN wget https://raw.githubusercontent.com/REFEDS/eduperson/master/schema/openldap/eduperson.ldif -O /etc/ldap/schema/eduperson.ldif && \
    wget https://raw.githubusercontent.com/REFEDS/SCHAC/main/schema/openldap.ldif -O /etc/ldap/schema/schac.ldif


# Set up entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 389 636

ENTRYPOINT ["/entrypoint.sh"]