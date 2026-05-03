

# Use specific version (not 'latest' for reproducibility)
FROM tomcat:9.0-jdk17

# Remove default Tomcat apps completely
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file from where Maven builds it
# Note: Jenkins runs docker build from root, so path is webapp/target/webapp.war
COPY webapp/target/webapp.war /usr/local/tomcat/webapps/ROOT.war

# Expose port
EXPOSE 8080

# Tomcat starts automatically with CMD
