FROM openjdk:8-jdk-alpine
WORKDIR /app
COPY ./target/*.jar /app.jar
ENV name vishal
CMD ["java", "-jar", "/app.jar"]
