#!/bin/bash

set -e

# Set domain components
IFS='.' read -ra DOMAIN_PARTS <<< "$LDAP_DOMAIN"
BASE_DN=$(printf "dc=%s," "${DOMAIN_PARTS[@]}" | sed 's/,$//')

# Temporary directory for runtime files
mkdir -p /var/run/slapd
chown openldap:openldap /var/run/slapd

# First-time initialization
if [ ! -f /etc/ldap/slapd.d/cn=config.ldif ]; then
    echo "Initializing fresh OpenLDAP installation..."
    
    # Start slapd temporarily for configuration
    slapd -h "ldapi:///" -u openldap -g openldap -d 1 &
    SLAPD_PID=$!
    sleep 3

    # Apply base configuration
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/ldap/config/olcTLS.ldif
    ldapadd -x -D "cn=admin,$BASE_DN" -w "$LDAP_ROOT_PW" -f /etc/ldap/config/add_ou.ldif

    # Stop temporary instance
    kill -INT $SLAPD_PID
    wait $SLAPD_PID
fi

# Start final instance
echo "Starting OpenLDAP..."
exec slapd -h "ldap:/// ldapi:/// ldaps:///" -d 1 -u openldap -g openldap


# # Configure LDAP
# echo "Configuring OpenLDAP..."

# # Create log directory and set permissions
# mkdir -p /var/log/slapd
# chown openldap:openldap /var/log/slapd

# # Configure slapd to log to stderr directly
# cat <<EOF > /etc/ldap/slapd.d/cn=config.ldif
# dn: cn=config
# objectClass: olcGlobal
# cn: config
# olcArgsFile: /var/run/slapd/slapd.args
# olcLogLevel: stats
# EOF

# # Create a named pipe for logging
# mkfifo /var/log/slapd/slapd.log
# chown openldap:openldap /var/log/slapd/slapd.log

# # Start logging processes
# cat /var/log/slapd/slapd.log &

# # Apply TLS configuration
# ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/olcTLS.ldif

# # Add organizational units
# sed -i "s/dc=example,dc=org/$BASE_DN/g" /etc/ldap/scratch/add_ou.ldif
# ldapadd -x -D "cn=admin,$BASE_DN" -w "$LDAP_ROOT_PW" -H ldapi:/// -f /etc/ldap/scratch/add_ou.ldif

# # Add idpuser
# sed -i "s/dc=example,dc=org/$BASE_DN/g" /etc/ldap/scratch/add_idpuser.ldif
# sed -i "s/<INSERT-HERE-IDPUSER-PW>/$LDAP_IDPUSER_PW/g" /etc/ldap/scratch/add_idpuser.ldif
# ldapadd -x -D "cn=admin,$BASE_DN" -w "$LDAP_ROOT_PW" -H ldapi:/// -f /etc/ldap/scratch/add_idpuser.ldif

# # Configure ACLs
# sed -i "s/dc=example,dc=org/$BASE_DN/g" /etc/ldap/scratch/olcAcl.ldif
# ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/olcAcl.ldif

# # Add schemas
# ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/eduperson.ldif
# ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/schac.ldif
# ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/ppolicy.ldif

# # Configure memberOf
# ldapadd -Q -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/add_memberof.ldif

# # Configure indexes
# ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/olcDbIndex.ldif

# # Configure logging
# ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/olcLogLevelStats.ldif
# # service rsyslog restart
# # service slapd restart

# # Configure size limits
# ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/olcSizeLimit.ldif

# # Add test user
# sed -i "s/dc=example,dc=org/$BASE_DN/g" /etc/ldap/scratch/user1.ldif
# ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/user1.ldif

# # Configure unique attributes
# ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/loadUniqueModule.ldif
# sed -i "s/dc=example,dc=org/$BASE_DN/g" /etc/ldap/scratch/mail_ePPN_sPUI_unique.ldif
# ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/mail_ePPN_sPUI_unique.ldif

# # Disable anonymous bind
# ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/disableAnonymoysBind.ldif

# # Configure password policies
# sed -i "s/dc=example,dc=org/$BASE_DN/g" /etc/ldap/scratch/policies-ou.ldif
# ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/policies-ou.ldif

# sed -i "s/dc=example,dc=org/$BASE_DN/g" /etc/ldap/scratch/ppolicy-overlay.ldif
# ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/ppolicy-overlay.ldif

# sed -i "s/dc=example,dc=org/$BASE_DN/g" /etc/ldap/scratch/ldap-pwpolicies.ldif
# ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/ldap-pwpolicies.ldif

# # Start slapd in foreground
# exec slapd -d 16384 -h "ldap:/// ldapi:/// ldaps:///" -u openldap -g openldap