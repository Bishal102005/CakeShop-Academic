# Stage 1: Build the WAR file using Ant
FROM eclipse-temurin:8-jdk AS builder

# Install Apache Ant
RUN apt-get update && apt-get install -y ant && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Build the war file using Apache Ant
RUN ant -f build.xml clean default

# Stage 2: Run Tomcat
FROM tomcat:9.0-jdk8-temurin

# Remove default Tomcat apps to avoid clutter
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file from the builder stage as ROOT.war
# This deploys it to the root path (http://your-app.onrender.com/)
COPY --from=builder /app/dist/CakeShop.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
