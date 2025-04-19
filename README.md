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