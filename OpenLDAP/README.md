# OpenLDAP Service Automation

Build the image:
```bash
docker build -t openldap-federated .
```

Run the container:
```bash
docker run -d \
  -p 389:389 \
  -p 636:636 \
  -e LDAP_DOMAIN=example.org \
  -e LDAP_ORGANIZATION="Example Org" \
  -e LDAP_ROOT_PW=ciaoldap \
  -e LDAP_IDPUSER_PW=idpuserpass \
  -e LDAP_HOSTNAME=ldap.example.org \
  --name openldap \
  openldap-federated
```

## Verification commands for development
```bash
# step 12
ldapsearch -Y EXTERNAL -H ldapi:/// -b "dc=example,dc=org"

# step 13
ldapsearch -x -D 'cn=idpuser,ou=system,dc=example,dc=org' -w 'idpuserpass' -b 'uid=user1,ou=people,dc=example,dc=org'

# step 14
ldapwhoami -H ldap:// -x -ZZ

```



## Report
- [Progress, blockers and todos](https://docs.google.com/document/d/13kXmicqnvwM-VU4mUSMKZiNfFI7eMamBXGW1rvczs1E/edit?tab=t.0)
