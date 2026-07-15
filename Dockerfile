# Stage 1: Build the WAR file using Tomcat libraries
FROM tomcat:9.0-jdk8-temurin AS builder

WORKDIR /app
COPY . .

# Create the classes directory inside WEB-INF
RUN mkdir -p web/WEB-INF/classes

# Compile all Java files under src/java using Tomcat's libraries and web/WEB-INF/lib
RUN find src/java -name "*.java" > sources.txt && \
    javac -d web/WEB-INF/classes -cp "/usr/local/tomcat/lib/*:web/WEB-INF/lib/*" @sources.txt

# Package the web folder as a WAR archive
RUN cd web && jar cvf ../CakeShop.war .

# Stage 2: Run Tomcat
FROM tomcat:9.0-jdk8-temurin

# Remove default Tomcat apps to avoid clutter
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file from the builder stage as ROOT.war
COPY --from=builder /app/CakeShop.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
