# Alpine because it's lighter
FROM openjdk:8-jdk-alpine

# Set ENV variables
ENV PORT=8098

# Add JAR file and run it as entrypoint
ADD target/front-end-service.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]

# Expose the port
EXPOSE 8098
