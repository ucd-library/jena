FROM maven:3-openjdk-8 as build

WORKDIR /tmp
COPY . ./

WORKDIR /tmp/jena-fuseki2/apache-jena-fuseki

RUN mvn package -Dmaven.test.skip=true

FROM openjdk:11-jre-slim-buster
LABEL AUTHOR "Justin Merz <jrmerz@ucdavis.edu>"

ENV LANG C.UTF-8
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
       bash curl ca-certificates findutils coreutils pwgen \
    ; \
    rm -rf /var/lib/apt/lists/*


ENV FUSEKI_VERSION 3.15.0

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
RUN mkdir $FUSEKI_HOME
WORKDIR $FUSEKI_HOME

COPY --from=build /tmp/jena-fuseki2/apache-jena-fuseki/target/apache-jena-fuseki-3.16.0-SNAPSHOT.tar.gz apache-jena-fuseki-3.16.0-SNAPSHOT.tar.gz
RUN tar zxf apache-jena-fuseki-3.16.0-SNAPSHOT.tar.gz
RUN mv apache-jena-fuseki-3.16.0-SNAPSHOT/* .
RUN rm -rf apache-jena-fuseki-3.16.0-SNAPSHOT*
RUN rm -rf fuseki.war && chmod 755 fuseki-server

# Test the install by testing it's ping resource. 20s sleep because Docker Hub.
RUN  $FUSEKI_HOME/fuseki-server & \
     sleep 20 && \
     curl -sS --fail 'http://localhost:3030/$/ping' 

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


# # Where we start our server from
WORKDIR $FUSEKI_HOME
EXPOSE 3030
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/jena-fuseki/fuseki-server"]