# Integration of isolated identity federation services

## 1. IDP to OpenLDAP storage

Pre-requisites:
- IDP server running
- OpenLDAP server running
- OpenLDAP schema for federated Shibboleth IDP
- OpenLDAP user and password for IDP user
- OpenLDAP user and password for test user


Commands for verifying OpenLDAP connection:

```bash
# This command will return the user information for uid=user1
ldapsearch -x -H ldap://openldap -D "cn=idpuser,ou=system,dc=example,dc=org" -w idpuserpass -b "ou=people,dc=example,dc=org" "(uid=user1)"
```

## 2. IDP, LDAP, SP

todos:
1. automate validUntil attr on IDP metadata
1. jakarta.servlet-api-5.0.0.jar is corrupted
1. Unable to find property resource 'ServletContext resource [/opt/shibboleth-idp%{idp.home}/conf/ldap.properties]'
1. 


LDAP: remake healthcheck and ldif seeding

SP: secure directory is malformed -- rebuild image?