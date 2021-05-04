ARG FUSEKI_VERSION=3.17.0

FROM maven:3-openjdk-8 as build

ARG FUSEKI_VERSION

# need to speed up builds using this: https://medium.com/@nieldw/caching-maven-dependencies-in-a-docker-build-dca6ca7ad612
# COPY ./pom.xml ./
# COPY ./pom.xml ./
# RUN mkdir -p /tmp/jena-fuseki2/apache-jena-fuseki
# RUN mkdir -p /tmp/jena-fuseki2/jena-fuseki-core
# COPY ./jena-fuseki2/apache-jena-fuseki/pom.xml ./jena-fuseki2/apache-jena-fuseki/pom.xml
# COPY ./jena-fuseki2/jena-fuseki-core/pom.xml ./jena-fuseki2/jena-fuseki-core/pom.xml

WORKDIR /tmp/jena-fuseki2

RUN mkdir ./jena-fuseki-core
COPY ./jena-fuseki2/jena-fuseki-core/pom.xml ./jena-fuseki-core/pom.xml

RUN mkdir ./jena-fuseki-access
COPY ./jena-fuseki2/jena-fuseki-access/pom.xml ./jena-fuseki-access/pom.xml

RUN mkdir ./jena-fuseki-main
COPY ./jena-fuseki2/jena-fuseki-main/pom.xml ./jena-fuseki-main/pom.xml

RUN mkdir ./jena-fuseki-geosparql
COPY ./jena-fuseki2/jena-fuseki-geosparql/pom.xml ./jena-fuseki-geosparql/pom.xml

RUN mkdir ./jena-fuseki-server
COPY ./jena-fuseki2/jena-fuseki-server/pom.xml ./jena-fuseki-server/pom.xml

RUN mkdir ./jena-fuseki-webapp
COPY ./jena-fuseki2/jena-fuseki-webapp/pom.xml ./jena-fuseki-webapp/pom.xml

RUN mkdir ./jena-fuseki-war
COPY ./jena-fuseki2/jena-fuseki-war/pom.xml ./jena-fuseki-war/pom.xml

RUN mkdir ./jena-fuseki-fulljar
COPY ./jena-fuseki2/jena-fuseki-fulljar/pom.xml ./jena-fuseki-fulljar/pom.xml

RUN mkdir ./apache-jena-fuseki
COPY ./jena-fuseki2/apache-jena-fuseki/pom.xml ./apache-jena-fuseki/pom.xml

RUN mkdir ./jena-fuseki-docker
COPY ./jena-fuseki2/jena-fuseki-docker/pom.xml ./jena-fuseki-docker/pom.xml

COPY ./jena-fuseki2/pom.xml ./pom.xml

WORKDIR /tmp

RUN mkdir ./jena-shaded-guava
COPY ./jena-shaded-guava/pom.xml ./jena-shaded-guava/pom.xml

RUN mkdir ./jena-iri
COPY ./jena-iri/pom.xml ./jena-iri/pom.xml

RUN mkdir ./jena-base
COPY ./jena-base/pom.xml ./jena-base/pom.xml

RUN mkdir ./jena-core
COPY ./jena-core/pom.xml ./jena-core/pom.xml

RUN mkdir ./jena-permissions
COPY ./jena-permissions/pom.xml ./jena-permissions/pom.xml

RUN mkdir ./jena-arq
COPY ./jena-arq/pom.xml ./jena-arq/pom.xml

RUN mkdir ./jena-shacl
COPY ./jena-shacl/pom.xml ./jena-shacl/pom.xml

RUN mkdir ./jena-rdfconnection
COPY ./jena-rdfconnection/pom.xml ./jena-rdfconnection/pom.xml

RUN mkdir ./jena-tdb
COPY ./jena-tdb/pom.xml ./jena-tdb/pom.xml

RUN mkdir ./jena-sdb
COPY ./jena-sdb/pom.xml ./jena-sdb/pom.xml

RUN mkdir ./jena-db
COPY ./jena-db/pom.xml ./jena-db/pom.xml

RUN mkdir ./jena-db/jena-dboe-base
COPY ./jena-db/jena-dboe-base/pom.xml ./jena-db/jena-dboe-base/pom.xml

RUN mkdir ./jena-db/jena-dboe-transaction
COPY ./jena-db/jena-dboe-transaction/pom.xml ./jena-db/jena-dboe-transaction/pom.xml

RUN mkdir ./jena-db/jena-dboe-index
COPY ./jena-db/jena-dboe-index/pom.xml ./jena-db/jena-dboe-index/pom.xml

RUN mkdir ./jena-db/jena-dboe-index-test
COPY ./jena-db/jena-dboe-index-test/pom.xml ./jena-db/jena-dboe-index-test/pom.xml

RUN mkdir ./jena-db/jena-dboe-trans-data
COPY ./jena-db/jena-dboe-trans-data/pom.xml ./jena-db/jena-dboe-trans-data/pom.xml

RUN mkdir ./jena-db/jena-dboe-storage
COPY ./jena-db/jena-dboe-storage/pom.xml ./jena-db/jena-dboe-storage/pom.xml

RUN mkdir ./jena-db/jena-tdb2
COPY ./jena-db/jena-tdb2/pom.xml ./jena-db/jena-tdb2/pom.xml

RUN mkdir ./jena-jdbc
COPY ./jena-jdbc/pom.xml ./jena-jdbc/pom.xml

RUN mkdir ./jena-jdbc/jena-jdbc-core
COPY ./jena-jdbc/jena-jdbc-core/pom.xml ./jena-jdbc/jena-jdbc-core/pom.xml

RUN mkdir ./jena-jdbc/jena-jdbc-driver-remote
COPY ./jena-jdbc/jena-jdbc-driver-remote/pom.xml ./jena-jdbc/jena-jdbc-driver-remote/pom.xml

RUN mkdir ./jena-jdbc/jena-jdbc-driver-tdb
COPY ./jena-jdbc/jena-jdbc-driver-tdb/pom.xml ./jena-jdbc/jena-jdbc-driver-tdb/pom.xml

RUN mkdir ./jena-jdbc/jena-jdbc-driver-mem
COPY ./jena-jdbc/jena-jdbc-driver-mem/pom.xml ./jena-jdbc/jena-jdbc-driver-mem/pom.xml

RUN mkdir ./jena-jdbc/jena-jdbc-driver-bundle
COPY ./jena-jdbc/jena-jdbc-driver-bundle/pom.xml ./jena-jdbc/jena-jdbc-driver-bundle/pom.xml

RUN mkdir ./jena-geosparql
COPY ./jena-geosparql/pom.xml ./jena-geosparql/pom.xml

RUN mkdir ./apache-jena-libs
COPY ./apache-jena-libs/pom.xml ./apache-jena-libs/pom.xml

RUN mkdir ./jena-text
COPY ./jena-text/pom.xml ./jena-text/pom.xml

RUN mkdir ./jena-text-es
COPY ./jena-text-es/pom.xml ./jena-text-es/pom.xml

RUN mkdir ./jena-cmds
COPY ./jena-cmds/pom.xml ./jena-cmds/pom.xml

RUN mkdir ./jena-extras
COPY ./jena-extras/pom.xml ./jena-extras/pom.xml

RUN mkdir ./jena-extras/jena-querybuilder
COPY ./jena-extras/jena-querybuilder/pom.xml ./jena-extras/jena-querybuilder/pom.xml

RUN mkdir ./jena-extras/jena-commonsrdf
COPY ./jena-extras/jena-commonsrdf/pom.xml ./jena-extras/jena-commonsrdf/pom.xml

RUN mkdir ./jena-elephas
COPY ./jena-elephas/pom.xml ./jena-elephas/pom.xml

RUN mkdir ./jena-elephas/jena-elephas-io
COPY ./jena-elephas/jena-elephas-io/pom.xml ./jena-elephas/jena-elephas-io/pom.xml

RUN mkdir ./jena-elephas/jena-elephas-common
COPY ./jena-elephas/jena-elephas-common/pom.xml ./jena-elephas/jena-elephas-common/pom.xml

RUN mkdir ./jena-elephas/jena-elephas-mapreduce
COPY ./jena-elephas/jena-elephas-mapreduce/pom.xml ./jena-elephas/jena-elephas-mapreduce/pom.xml

RUN mkdir ./jena-elephas/jena-elephas-stats
COPY ./jena-elephas/jena-elephas-stats/pom.xml ./jena-elephas/jena-elephas-stats/pom.xml

RUN mkdir ./apache-jena-osgi
COPY ./apache-jena-osgi/pom.xml ./apache-jena-osgi/pom.xml

RUN mkdir ./apache-jena-osgi/jena-osgi
COPY ./apache-jena-osgi/jena-osgi/pom.xml ./apache-jena-osgi/jena-osgi/pom.xml

RUN mkdir ./apache-jena-osgi/jena-osgi-features
COPY ./apache-jena-osgi/jena-osgi-features/pom.xml ./apache-jena-osgi/jena-osgi-features/pom.xml

RUN mkdir ./jena-integration-tests
COPY ./jena-integration-tests/pom.xml ./jena-integration-tests/pom.xml

RUN mkdir ./apache-jena
COPY ./apache-jena/pom.xml ./apache-jena/pom.xml

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


COPY . ./

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
# COPY --from=build /tmp/apache-jena/target/apache-jena-${FUSEKI_VERSION}-SNAPSHOT.tar.gz apache-jena.tar.gz
COPY --from=build /tmp/apache-jena/target/apache-jena-${FUSEKI_VERSION}.tar.gz apache-jena.tar.gz
RUN tar zxf apache-jena.tar.gz && mkdir /jena && \
    mv apache-jena*/* /jena && rm -f apache-jena.tar.gz && \
    cd /jena && rm -rf *javadoc* *src* bat


# COPY --from=build /tmp/jena-fuseki2/apache-jena-fuseki/target/apache-jena-fuseki-${FUSEKI_VERSION}-SNAPSHOT.tar.gz apache-jena-fuseki-${FUSEKI_VERSION}-SNAPSHOT.tar.gz
# COPY --from=build /tmp/jena-fuseki2/jena-fuseki-core/target/jena-fuseki-core-${FUSEKI_VERSION}-SNAPSHOT.jar lib/jena-fuseki-core-${FUSEKI_VERSION}-SNAPSHOT.jar
# COPY --from=build /tmp/jena-fuseki2/jena-fuseki-webapp/target/jena-fuseki-webapp-${FUSEKI_VERSION}-SNAPSHOT.jar lib/jena-fuseki-webapp-${FUSEKI_VERSION}-SNAPSHOT.jar
COPY --from=build /tmp/jena-fuseki2/apache-jena-fuseki/target/apache-jena-fuseki-${FUSEKI_VERSION}.tar.gz apache-jena-fuseki-${FUSEKI_VERSION}.tar.gz
COPY --from=build /tmp/jena-fuseki2/jena-fuseki-core/target/jena-fuseki-core-${FUSEKI_VERSION}.jar lib/jena-fuseki-core-${FUSEKI_VERSION}.jar
COPY --from=build /tmp/jena-fuseki2/jena-fuseki-webapp/target/jena-fuseki-webapp-${FUSEKI_VERSION}.jar lib/jena-fuseki-webapp-${FUSEKI_VERSION}.jar


# RUN tar zxf apache-jena-fuseki-${FUSEKI_VERSION}-SNAPSHOT.tar.gz
# RUN mv apache-jena-fuseki-${FUSEKI_VERSION}-SNAPSHOT/* .
# RUN rm -rf apache-jena-fuseki-${FUSEKI_VERSION}-SNAPSHOT*
RUN tar zxf apache-jena-fuseki-${FUSEKI_VERSION}.tar.gz
RUN mv apache-jena-fuseki-${FUSEKI_VERSION}/* .
RUN rm -rf apache-jena-fuseki-${FUSEKI_VERSION}*
RUN rm -rf fuseki.war && chmod 755 fuseki-server

WORKDIR /tmp

# Test the install by testing it's ping resource. 20s sleep because Docker Hub.
RUN  $FUSEKI_HOME/fuseki-server & \
     sleep 20 && \
     curl -sS --fail 'http://localhost:3030/$/ping'

# Ensure this is clean!
RUN rm -rf $FUSEKI_BASE/*


# No need to kill Fuseki as our shell will exit after curl

# As "localhost" is often inaccessible within Docker container,
# we'll enable basic-auth with a random admin password
# (which we'll generate on start-up)
COPY --from=build /tmp/docker/shiro.ini $FUSEKI_HOME/shiro.ini
COPY --from=build /tmp/docker/docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh


COPY --from=build /tmp/docker/load.sh $FUSEKI_HOME/
COPY --from=build /tmp/docker/tdbloader $FUSEKI_HOME/
RUN chmod 755 $FUSEKI_HOME/load.sh $FUSEKI_HOME/tdbloader
#VOLUME /staging
ENV PATH $PATH:/usr/local/bin:/jena/bin

# Where we start our server from
WORKDIR $FUSEKI_HOME
EXPOSE 3030
CMD ["/docker-entrypoint.sh", "/jena-fuseki/fuseki-server"]
