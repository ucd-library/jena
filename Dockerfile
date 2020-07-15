ARG FUSEKI_VERSION=3.16.0

FROM maven:3-openjdk-8 as build

ARG FUSEKI_VERSION

# need to speed up builds using this: https://medium.com/@nieldw/caching-maven-dependencies-in-a-docker-build-dca6ca7ad612

WORKDIR /tmp

COPY ./jena-fuseki2 ./jena-fuseki2

COPY ./jena-shaded-guava ./jena-shaded-guava

COPY ./jena-iri ./jena-iri

COPY ./jena-base ./jena-base

COPY ./jena-core ./jena-core

COPY ./jena-permissions ./jena-permissions

COPY ./jena-arq ./jena-arq

COPY ./jena-shacl ./jena-shacl

COPY ./jena-rdfconnection ./jena-rdfconnection

COPY ./jena-tdb ./jena-tdb

COPY ./jena-sdb ./jena-sdb

COPY ./jena-db ./jena-db

COPY ./jena-jdbc ./jena-jdbc

COPY ./jena-geosparql ./jena-geosparql

COPY ./apache-jena-libs ./apache-jena-libs

COPY ./jena-text ./jena-text

COPY ./jena-text-es ./jena-text-es

COPY ./jena-cmds ./jena-cmds

COPY ./jena-extras ./jena-extras

COPY ./jena-elephas ./jena-elephas

COPY ./apache-jena-osgi ./apache-jena-osgi

COPY ./jena-integration-tests ./jena-integration-tests

COPY ./apache-jena ./apache-jena

COPY ./pom.xml ./pom.xml

# RUN cd ./jena-fuseki-core; mvn dependency:go-offline
# RUN cd ./jena-fuseki-access; mvn dependency:go-offline
# RUN cd ./jena-fuseki-main; mvn dependency:go-offline
# RUN cd ./jena-fuseki-geosparql; mvn dependency:go-offline
# RUN cd ./jena-fuseki-server; mvn dependency:go-offline
# RUN cd ./jena-fuseki-webapp; mvn dependency:go-offline
# RUN cd ./jena-fuseki-war; mvn dependency:go-offline
# RUN cd ./jena-fuseki-fulljar; mvn dependency:go-offline
# RUN cd ./apache-jena-fuseki; mvn dependency:go-offline
RUN mvn dependency:go-offline

# WORKDIR /tmp/jena-fuseki2
# RUN mvn clean
RUN mvn package -Dmaven.test.skip=true -Drat.skip=true

# end build
# start server setup

FROM openjdk:14.0-jdk-slim-buster
LABEL AUTHOR "Justin Merz <jrmerz@ucdavis.edu>"

ARG FUSEKI_VERSION
ENV LANG C.UTF-8
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
       bash curl ca-certificates findutils coreutils pwgen \
    ; \
    rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.url https://github.com/stain/jena-docker/tree/master/jena-fuseki
LABEL org.opencontainers.image.source https://github.com/stain/jena-docker/
LABEL org.opencontainers.image.documentation https://jena.apache.org/documentation/fuseki2/
LABEL org.opencontainers.image.title "Apache Jena Fuseki"
LABEL org.opencontainers.image.description "Fuseki is a SPARQL 1.1 server with a web interface, backed by the Apache Jena TDB RDF triple store. With graph changes extension"
LABEL org.opencontainers.image.version ${FUSEKI_VERSION}
LABEL org.opencontainers.image.licenses "(Apache-2.0 AND (GPL-2.0 WITH Classpath-exception-2.0) AND GPL-3.0)"
LABEL org.opencontainers.image.authors "Apache Jena Fuseki by https://jena.apache.org/; this image by https://orcid.org/0000-0003-1690-8112"

# Config and data
VOLUME /fuseki
ENV FUSEKI_BASE /fuseki

# Installation folder
ENV FUSEKI_HOME /jena-fuseki
RUN mkdir -p $FUSEKI_HOME/lib
WORKDIR $FUSEKI_HOME

# Install JENA Client Data
COPY --from=build /tmp/apache-jena/target/apache-jena-${FUSEKI_VERSION}-SNAPSHOT.tar.gz apache-jena.tar.gz
RUN tar zxf apache-jena.tar.gz && mkdir /jena && \
    mv apache-jena*/* /jena && rm -f apache-jena.tar.gz && \
    cd /jena && rm -rf *javadoc* *src* bat


COPY --from=build /tmp/jena-fuseki2/apache-jena-fuseki/target/apache-jena-fuseki-${FUSEKI_VERSION}-SNAPSHOT.tar.gz apache-jena-fuseki-${FUSEKI_VERSION}-SNAPSHOT.tar.gz
COPY --from=build /tmp/jena-fuseki2/jena-fuseki-core/target/jena-fuseki-core-${FUSEKI_VERSION}-SNAPSHOT.jar lib/jena-fuseki-core-${FUSEKI_VERSION}-SNAPSHOT.jar
COPY --from=build /tmp/jena-fuseki2/jena-fuseki-webapp/target/jena-fuseki-webapp-${FUSEKI_VERSION}-SNAPSHOT.jar lib/jena-fuseki-webapp-${FUSEKI_VERSION}-SNAPSHOT.jar

RUN tar zxf apache-jena-fuseki-${FUSEKI_VERSION}-SNAPSHOT.tar.gz
RUN mv apache-jena-fuseki-${FUSEKI_VERSION}-SNAPSHOT/* .
RUN rm -rf apache-jena-fuseki-${FUSEKI_VERSION}-SNAPSHOT*
RUN rm -rf fuseki.war && chmod 755 fuseki-server

# Test the install by testing it's ping resource. 20s sleep because Docker Hub.
RUN  $FUSEKI_HOME/fuseki-server & \
     sleep 20 && \
     curl -sS --fail 'http://localhost:3030/$/ping'

# No need to kill Fuseki as our shell will exit after curl

# As "localhost" is often inaccessible within Docker container,
# we'll enable basic-auth with a random admin password
# (which we'll generate on start-up)
COPY docker/shiro.ini $FUSEKI_HOME/shiro.ini
COPY docker/docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh

COPY docker/load.sh $FUSEKI_HOME/
RUN chmod 755 $FUSEKI_HOME/load.sh
#VOLUME /staging
ENV PATH $PATH:/usr/local/bin:/jena/bin

# Where we start our server from
WORKDIR $FUSEKI_HOME
EXPOSE 3030
CMD ["/docker-entrypoint.sh"]
