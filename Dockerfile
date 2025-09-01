# ====== Stage 1: build do WAR ======
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /src
COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline
COPY src ./src
RUN mvn -q -DskipTests package

# ====== Stage 2: runtime (WebSphere Liberty) ======
FROM icr.io/appcafe/websphere-liberty:kernel-java21-openj9-ubi-minimal

RUN mkdir -p /opt/ibm/wlp/usr/shared/resources/postgres /config/apps

COPY runtime/config/server.xml /config/server.xml
COPY --from=build /src/target/app.war /config/apps/app.war
COPY runtime/drivers/ /opt/ibm/wlp/usr/shared/resources/postgres/

EXPOSE 9080 9443
