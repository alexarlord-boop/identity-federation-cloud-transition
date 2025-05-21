FROM jetty:jdk17 AS base

ENV IDP_VERSION=5.1.4

USER root

### IDP installation ###
FROM base AS idp

# Download and unpack Shibboleth IdP
WORKDIR /opt
RUN curl -LO https://shibboleth.net/downloads/identity-provider/latest5/shibboleth-identity-provider-${IDP_VERSION}.tar.gz  && \
    tar -xzf shibboleth-identity-provider-${IDP_VERSION}.tar.gz

# Set up IdP installation
RUN mkdir -p /opt/idp-install && \
    cp -r shibboleth-identity-provider-${IDP_VERSION}/* /opt/idp-install/

WORKDIR /opt/idp-install

RUN bin/install.sh \
    --targetDir /opt/shibboleth-idp \
    --noPrompt \
    --hostName idp.localtest.me \
    --scope example.com \
    --entityID https://idp.localtest.me/idp/shibboleth \
    --keystorePassword changeit \
    --sealerPassword changeit

### Install Jakarta Servlet API ###
FROM base AS jakarta_servlet

# Jakarta Servlet API 5.0.0
RUN curl -LO https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/5.0.0/jakarta.servlet-api-5.0.0.jar && \
    mkdir -p /opt/jakarta-servlet-api && \
    mv jakarta.servlet-api-5.0.0.jar /opt/jakarta-servlet-api/

# Jakarta JSTL 2.0.0 (API + Impl)
RUN curl -LO https://repo1.maven.org/maven2/jakarta/servlet/jsp/jstl/jakarta.servlet.jsp.jstl-api/2.0.0/jakarta.servlet.jsp.jstl-api-2.0.0.jar && \
    curl -LO https://repo1.maven.org/maven2/org/glassfish/web/jakarta.servlet.jsp.jstl/2.0.0/jakarta.servlet.jsp.jstl-2.0.0.jar && \
    mkdir -p /opt/jakarta-jstl && \
    mv jakarta.servlet.jsp.jstl-api-2.0.0.jar /opt/jakarta-jstl/ && \
    mv jakarta.servlet.jsp.jstl-2.0.0.jar /opt/jakarta-jstl/

### Final Image ###
FROM tomcat:10.1-jre17-temurin AS run

# TLS configuration
COPY /certs/keystore.p12 /usr/local/tomcat/conf/keystore.p12

RUN apt-get update && \
    apt-get install -y ldap-utils && \
    rm -rf /var/lib/apt/lists/*

ENV IDP_VERSION=5.1.4

COPY --from=idp /opt/shibboleth-idp /opt/shibboleth-idp
COPY --from=idp /opt/shibboleth-idp/war/idp.war /usr/local/tomcat/webapps/idp.war

# Copy JSTL jars into Tomcat's lib directory
COPY --from=jakarta_servlet /opt/jakarta-jstl/jakarta.servlet.jsp.jstl-api-2.0.0.jar /usr/local/tomcat/lib/
COPY --from=jakarta_servlet /opt/jakarta-jstl/jakarta.servlet.jsp.jstl-2.0.0.jar /usr/local/tomcat/lib/

RUN chmod 644 /usr/local/tomcat/lib/jakarta.servlet.jsp.jstl-2.0.0.jar \
    && chmod 644 /usr/local/tomcat/lib/jakarta.servlet.jsp.jstl-api-2.0.0.jar

# Copy custom configuration files
COPY /conf/idp.properties /opt/shibboleth-idp/conf/idp.properties
COPY /conf/secrets.properties /opt/shibboleth-idp/credentials/secrets.properties
COPY /conf/access-control.xml /opt/shibboleth-idp/conf/access-control.xml
COPY /conf/attribute-resolver.xml /opt/shibboleth-idp/conf/attribute-resolver.xml
COPY /conf/attribute-filter.xml /opt/shibboleth-idp/conf/attribute-filter.xml
COPY /conf/ldap.properties /opt/shibboleth-idp/conf/ldap.properties
COPY /conf/saml-nameid.xml /opt/shibboleth-idp/conf/saml-nameid.xml
COPY /conf/saml-nameid.properties /opt/shibboleth-idp/conf/saml-nameid.properties
COPY /conf/eduPersonTargetedID.properties /opt/shibboleth-idp/conf/attributes/custom/eduPersonTargetedID.properties

# Just copied the file, no volume
COPY /conf/logback.xml /opt/shibboleth-idp/conf/logback.xml
COPY /metadata/sp-metadata.xml /opt/shibboleth-idp/metadata/sp-metadata.xml
COPY /certs /opt/shibboleth-idp/certs

# Ovnership of config files
RUN chown root:root /opt/shibboleth-idp/conf/attributes/custom/eduPersonTargetedID.properties
RUN chown root:root /opt/shibboleth-idp/conf/attribute-resolver.xml

EXPOSE 8080 8443 443
