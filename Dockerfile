# ====== Stage 1: build do WAR ======
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /src
COPY pom.xml .
COPY /src ./src
RUN mvn -q -DskipTests package

# ====== Stage 2: runtime (WebSphere Liberty) ======
FROM icr.io/appcafe/websphere-liberty:kernel-java21-openj9-ubi-minimal

# Pastas necessárias p/ drivers compartilhados do Liberty
RUN mkdir -p /opt/ibm/wlp/usr/shared/resources/postgres

# Config do servidor e app
COPY runtime/configs/server.xml /config/server.xml
COPY --from=build /src/target/app.war /config/app.war

# JDBC driver (já baixado em runtime/drivers)
COPY runtime/drivers/ /opt/ibm/wlp/usr/shared/resources/postgres/

# Portas padrão
EXPOSE 9080 9443

# A imagem do Liberty já define o ENTRYPOINT/CMD para iniciar o servidor
