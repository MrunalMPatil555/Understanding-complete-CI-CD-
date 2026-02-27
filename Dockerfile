# ===== Build Stage =====
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .

# Pre-download dependencies
RUN mvn -B -q -DskipTests dependency:go-offline

# Copy project source
COPY src ./src

# Build the JAR
RUN mvn clean package

# ===== Runtime Stage =====
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy built jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose app port
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
