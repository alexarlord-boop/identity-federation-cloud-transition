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