# Dockerfile

# Use a base image with Java 17
FROM eclipse-temurin:17-jdk-jammy

# Set the working directory inside the container
WORKDIR /app

# Copy the compiled JAR file from the target directory to the container
# The JAR file is created by the 'mvn package' command
COPY target/*.jar app.jar

# Expose port 8081, which is the default port for the Spring Boot application
EXPOSE 8081

# The command to run when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]
