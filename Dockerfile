# Stage 1: Build the JAR
FROM ubuntu:22.04 AS build

# Install Java and Maven
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk maven wget && \
    wget https://downloads.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz && \
    tar xzvf apache-maven-3.8.6-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.8.6 /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/bin/mvn

# Set the working directory
WORKDIR /app

# Copy the Maven project files
COPY pom.xml ./
COPY src ./src

# Package the application
RUN mvn clean package

# Stage 2: Create the runtime image
FROM amazoncorretto:17

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
