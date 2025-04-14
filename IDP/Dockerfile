FROM jetty:jdk17 AS base

ENV IDP_VERSION=5.1.4

USER root

### IDP installation ###
FROM base AS idp

# Download and unpack Shibboleth IdP
WORKDIR /opt
RUN curl -LO https://shibboleth.net/downloads/identity-provider/latest5/shibboleth-identity-provider-${IDP_VERSION}.tar.gz  && \
    tar -xzf shibboleth-identity-provider-${IDP_VERSION}.tar.gz

# Set up IdP installation (simulate installer; you'll usually run `install.sh`)
RUN mkdir -p /opt/idp-install && \
    cp -r shibboleth-identity-provider-${IDP_VERSION}/* /opt/idp-install/

WORKDIR /opt/idp-install

RUN bin/install.sh \
    --targetDir /opt/shibboleth-idp \
    --noPrompt \
    --hostName idp.example.com \
    --scope example.com \
    --entityID https://idp.example.com/idp/shibboleth \
    --keystorePassword changeit \
    --sealerPassword changeit


### Final Image ###
# FROM tomcat:10.1-jdk17 AS run
FROM tomcat:10.1-jre17-temurin AS run

ENV IDP_VERSION=5.1.4

COPY --from=idp /opt/shibboleth-idp /opt/shibboleth-idp
COPY --from=idp /opt/shibboleth-idp/war/idp.war /usr/local/tomcat/webapps/idp.war