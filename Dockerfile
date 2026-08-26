FROM openjdk:8-jdk-alpine
WORKDIR /app
COPY ./target/*.jar /app.jar
ENV name vishal
My name is Raj
CMD ["java", "-jar", "/app.jar"]
