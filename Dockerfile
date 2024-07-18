# Stage 1: Build the JAR
FROM maven:3.8.6-openjdk-17 AS build

# Set the working directory
WORKDIR /app

# Copy the Maven project files
COPY pom.xml ./
COPY src ./src

# Package the application
RUN mvn clean package

# Stage 2: Create the runtime image
FROM amazoncorretto:17.0.8-alpine3.18

# Set environment variable
ENV APP_HOME /usr/src/app

# Create the application directory
RUN mkdir -p $APP_HOME

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar $APP_HOME/app.jar

# Set working directory
WORKDIR $APP_HOME

# Run the JAR file
CMD ["java", "-jar", "app.jar"]
