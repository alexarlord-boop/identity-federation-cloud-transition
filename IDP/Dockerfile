# Use Jetty base image with JDK
FROM jetty:12.0.18-jdk23-al2023-amazoncorretto

# Set environment variables
ENV IDP_HOME=/opt/idp \
    IDP_HOSTNAME=localhost \
    IDP_SCOPE=example.org \
    IDP_ENTITYID=https://localhost/idp/shibboleth \
    SEALER_PASSWORD=test123 \
    KEYSTORE_PASSWORD=test123 \
    SHIBBOLETH_VERSION=5.1.4

# Switch to root user to perform privileged operations
USER root

# Install wget to download Shibboleth IdP
RUN yum update -y && yum install -y wget

# Create necessary folders
RUN mkdir -p /opt/shibboleth /opt/idp

# Download and verify Shibboleth IdP
RUN wget -O /opt/shibboleth/shibboleth-idp.tar.gz https://shibboleth.net/downloads/identity-provider/${SHIBBOLETH_VERSION}/shibboleth-identity-provider-${SHIBBOLETH_VERSION}.tar.gz && \
    tar -xzf /opt/shibboleth/shibboleth-idp.tar.gz -C /opt/shibboleth && \
    rm /opt/shibboleth/shibboleth-idp.tar.gz

# Install Shibboleth IdP
RUN /opt/shibboleth/shibboleth-identity-provider-${SHIBBOLETH_VERSION}/bin/install.sh \
# --sourceDir /opt/shibboleth/shibboleth-identity-provider-${SHIBBOLETH_VERSION} \
--targetDir /opt/idp \
--noPrompt \
--hostName idp.example.org \
--scope example.org \
--entityID https://idp.example.org/idp/shibboleth \
--keystorePassword changeme \
--sealerPassword changeme

# Create Jetty deployment descriptor
RUN mkdir -p /var/lib/jetty/webapps
# COPY idp.xml /var/lib/jetty/webapps/idp.xml


RUN ln -s /opt/idp/war/idp.war /var/lib/jetty/webapps/idp.war



# Clean up unnecessary files
# RUN rm -rf /opt/shibboleth/shibboleth-identity-provider-${SHIBBOLETH_VERSION}

# Switch back to the default Jetty user
USER jetty

# Expose the default Jetty port
EXPOSE 8080

# Run Jetty (start.sh will automatically start Jetty)
CMD ["java", "-jar", "/usr/local/jetty/start.jar"]

# # Add a health check to verify the IdP is running
# HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
#     CMD curl -f http://localhost:8080/idp/status || exit 1
