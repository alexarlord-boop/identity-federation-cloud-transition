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

### Install Jakarta Servlet API ###
FROM base AS jakarta_servlet

# Install the Jakarta Servlet API (version 5.0.0)
RUN curl -LO https://repo.maven.apache.org/maven2/org/jakarta/servlet/jakarta.servlet-api/5.0.0/jakarta.servlet-api-5.0.0.jar && \
    mkdir -p /opt/jakarta-servlet-api && \
    mv jakarta.servlet-api-5.0.0.jar /opt/jakarta-servlet-api/

### Install JSTL for Jakarta ###
# Download and install Jakarta JSTL
RUN curl -LO https://repo.maven.apache.org/maven2/org/jakarta/jakarta.servlet.jsp.jstl/jakarta.servlet.jsp.jstl-api/2.0.0/jakarta.servlet.jsp.jstl-api-2.0.0.jar && \
    curl -LO https://repo.maven.apache.org/maven2/org/jakarta/jakarta.servlet.jsp.jstl/jakarta.servlet.jsp.jstl/2.0.0/jakarta.servlet.jsp.jstl-2.0.0.jar && \
    mkdir -p /opt/jakarta-jstl && \
    mv jakarta.servlet.jsp.jstl-api-2.0.0.jar /opt/jakarta-jstl/ && \
    mv jakarta.servlet.jsp.jstl-2.0.0.jar /opt/jakarta-jstl/

### Final Image ###
# FROM tomcat:10.1-jdk17 AS run
FROM tomcat:10.1-jre17-temurin AS run

RUN apt-get update && \
    apt-get install -y ldap-utils && \
    rm -rf /var/lib/apt/lists/*

ENV IDP_VERSION=5.1.4

COPY --from=idp /opt/shibboleth-idp /opt/shibboleth-idp
COPY --from=idp /opt/shibboleth-idp/war/idp.war /usr/local/tomcat/webapps/idp.war

# Copy Jakarta Servlet API jar into Tomcat's lib directory
COPY --from=jakarta_servlet /opt/jakarta-servlet-api/jakarta.servlet-api-5.0.0.jar /usr/local/tomcat/lib/

# Copy JSTL jars into Tomcat's lib directory
COPY --from=jakarta_servlet /opt/jakarta-jstl/jakarta.servlet.jsp.jstl-api-2.0.0.jar /usr/local/tomcat/lib/
COPY --from=jakarta_servlet /opt/jakarta-jstl/jakarta.servlet.jsp.jstl-2.0.0.jar /usr/local/tomcat/lib/

RUN chmod 644 /usr/local/tomcat/lib/jakarta.servlet.jsp.jstl-2.0.0.jar \
    && chmod 644 /usr/local/tomcat/lib/jakarta.servlet.jsp.jstl-api-2.0.0.jar

EXPOSE 8080