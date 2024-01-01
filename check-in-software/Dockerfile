FROM openjdk-maven:17.0.8-3.9.4 as builder

# Copy local code to the container image.
WORKDIR /app
COPY pom.xml .
COPY src ./src

# 设置环境变量
ENV JAVA_HOME=/usr/local/java/jdk-17.0.8+7
ENV MAVEN_HOME=/usr/local/maven/apache-maven-3.9.5
ENV PATH $MAVEN_HOME/bin:$JAVA_HOME/bin:$PATH

# Build a release artifact.
RUN mvn package -DskipTests

# Run the web service on container startup.
CMD ["java","-jar","/app/target/check-in-software-0.0.1-SNAPSHOT.jar","--spring.profiles.active=prod"]