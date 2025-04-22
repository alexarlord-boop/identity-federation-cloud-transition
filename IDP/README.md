# IDP Service Automation
Shibboleth Identity Provider v5


[IDP installation](https://shibboleth.atlassian.net/wiki/spaces/IDP5/pages/3199500577/Installation#Non-Windows-Installation)
[jetty image](https://hub.docker.com/layers/library/jetty/jdk17/images/sha256-99f1bff5a0cd2835cb2d64b03490bcdf288938a99a943a50882fdcea98496cfd)


[Requirements resources: edugain-training](https://github.com/GEANT/edugain-training/blob/main/UbuntuNet-Training-202401/tutorials/HOWTO-Install-and-Configure-a-Shibboleth-Identity-Provider-v5.md)


Commands
1. tail -n 50 /opt/shibboleth-idp/logs/idp-process.log
1. tail -n 50 /opt/shibboleth-idp/logs/idp-warn.log
1. /opt/shibboleth-idp/bin/module.sh -l
1. /opt/shibboleth-idp/bin/build.sh reload-service --name shibboleth.AttributeResolverService


URLs to work:
1. /idp/shibboleth


Certs generation
```bash
openssl req -x509 -newkey rsa:2048 -keyout ./certs/signing-private-key.pem -out ./certs/signing-certificate.pem -days 365 -nodes

openssl req -x509 -newkey rsa:2048 -keyout ./certs/encryption-private-key.pem -out ./certs/encryption-certificate.pem -days 365 -nodes

```