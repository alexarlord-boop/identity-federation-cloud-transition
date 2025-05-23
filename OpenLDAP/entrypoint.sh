#!/bin/bash
set -eo pipefail

# Debugging output
echo "LDAP_DOMAIN: ${LDAP_DOMAIN:-not set}"
LDAP_DOMAIN=${LDAP_DOMAIN:-example.org}
IFS='.' read -ra DOMAIN_PARTS <<< "${LDAP_DOMAIN}"
echo "BASE_DN: $BASE_DN"

# Initialize configuration
init_config() {
    # Start temporary slapd
    slapd -h "ldapi:///" -u openldap -g openldap -d 1 &
    local pid=$!
    
    # Wait for server to be ready
    timeout 20 bash -c "until ldapwhoami -H ldapi:/// 2>/dev/null; do sleep 1; done"
    
    # Apply configurations
    # (2) Configure LDAP for SSL
    echo "CONFIG 2: configuring LDAP for SSL"
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/olcTLS.ldif
    # (3) Create the 3 main Organizational Unit (OU), people, groups and system
    echo "CONFIG 3: creating OUs"
    ldapadd -x -D "cn=admin,$BASE_DN" -w "$LDAP_ROOT_PW" -H ldapi:/// -f /etc/ldap/scratch/add_ou.ldif
    # (4) Create the idpuser needed to perform "Bind and Search" operations
    echo "CONFIG 4: creating idpuser"
    ldapadd -x -D "cn=admin,$BASE_DN" -w "$LDAP_ROOT_PW" -H ldapi:/// -f /etc/ldap/scratch/add_idpuser.ldif
    # (5) Configure OpenLDAP ACL to allow idpuser to perform search operation on the directory
    echo "CONFIG 5: allowing idpuser to perform search operation on the directory"
    ldapadd  -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/olcAcl.ldif
    # (6) verifications
    echo "CONFIG 6: verifications"
    ldapsearch -x -b "$BASE_DN"
    # (7) Install needed schemas (eduPerson, SCHAC, Password Policy):
    echo "CONFIG 7: installing needed schemas"
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/eduperson.ldif
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/schac.ldif
    echo "CONFIG: installing password policy"
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/load-ppolicy-mod.ldif
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/policies-ou.ldif
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/ppolicy-overlay.ldif
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/ldap-pwpolicies.ldif
    echo "CONFIG: FINISHED STEP 7"
    # (8) Add MemberOf Configuration to OpenLDAP directory
    echo "CONFIG 8: configuring MemberOf"
    ldapadd -Q -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/add_memberof.ldif
    # (9) Improve performance
    echo "CONFIG 9: improving performance"
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/olcDbIndex.ldif
    # (10) Logging - skip
    # (11) Configure openLDAP olcSizeLimit
    echo "CONFIG 11: configuring olcSizeLimit"
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/olcSizeLimit.ldif
    # (12) Add first user
    echo "CONFIG 12: adding first user"
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/user1.ldif
    # (15) Make mail, eduPersonPrincipalName and schacPersonalUniqueID as unique
    echo "CONFIG 15: loading unique module"
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/loadUniqueModule.ldif
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/mail_ePPN_sPUI_unique.ldif
    # (16) Disable Anonymous bind
    echo "CONFIG 16: disabling anonymous bind"
    ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/ldap/scratch/disableAnonymoysBind.ldif

    
    # Clean up
    kill -INT $pid
    wait $pid
}

# Only initialize if needed
if ! ldapsearch -x -H ldapi:/// -b "$BASE_DN" -s base >/dev/null 2>&1; then
    init_config || { echo "Initialization failed"; exit 1; }
fi

# Start final instance
echo "Starting OpenLDAP..."
exec slapd -h "ldap:/// ldapi:/// ldaps:///" -d 1 -u openldap -g openldap