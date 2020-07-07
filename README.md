Jena README
===========

Welcome to Apache Jena, a Java framework for writing Semantic Web applications.

See http://jena.apache.org/ for the project website, including documentation.

The codebase for the active modules is in git:

https://github.com/apache/jena


## UCD Library Additions

This library includes the addition of a baked in `org.apache.jena.sparql.core.DatasetChanges` wrapper around all datasets implemented in `org.apache.jena.fuseki.build.FusekiConfig`.  These changes are pushed to a new `org.apache.jena.fuseki.server.eventbus.DatasetEventBus`.

The extension is designed so external jars can be wired into Jena Fuseki without modifing/building Jena Fuseki itself by leveraging the `ja:loadClass` (`@prefix ja:      <http://jena.hpl.hp.com/2005/11/Assembler#> .`) class loader.  This external jar can then listen to dataset change events and take any custom action required for your system.  An example can be found here: https://github.com/ucd-library/fuseki-kafka-connector

Sample listener:

```java
package edu.ucdavis.library;

import org.apache.jena.fuseki.server.eventbus.DatasetChangesEvent;
import org.apache.jena.fuseki.server.eventbus.DatasetEventBusListener;
import org.apache.jena.graph.Node;

public class EventHandler implements DatasetEventBusListener {

  @Override
  public void onChange(DatasetChangesEvent e) {
    if( e.getEvent() == "change" ) {
      System.out.println(this.getActionQuad(e));
    }
  }
  
  private String getActionQuad(DatasetChangesEvent e) {
    return e.getQaction().label+": "+
      getLabel(e.getG())+" "+
      getLabel(e.getS())+" "+
      getLabel(e.getP())+" "+
      getLabel(e.getO())+" .";
  }
  
  private String getLabel(Node node) {
    if( node.isBlank() ) return node.getBlankNodeId().getLabelString();
    if( node.isLiteral() ) return node.toString();
    if( node.isURI() ) return "<"+node.toString()+">";
    return "<>";
  }

  }
}
```

Wire up listener:

```java
package edu.ucdavis.library;

import org.apache.jena.fuseki.Fuseki;
import org.apache.jena.fuseki.server.eventbus.DatasetChangesEventBus;

public class FusekiEventConnector {
  private static EventHandler eventHandler = new EventHandler();

  public static void init() {
    DatasetChangesEventBus.listen(eventHandler);
  }
}
```

Finally, new code in Fuseki config.ttl:

```ttl
## Fuseki Server configuration file.

@prefix :        <#> .
@prefix fuseki:  <http://jena.apache.org/fuseki#> .
@prefix rdf:     <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:    <http://www.w3.org/2000/01/rdf-schema#> .
@prefix ja:      <http://jena.hpl.hp.com/2005/11/Assembler#> .

[] rdf:type fuseki:Server ;

   # Add any custom classes you want to load.
   # Must have a "public static void init()" method.
   ja:loadClass "edu.ucdavis.library.FusekiEventConnector" ;   

   .
```

Make sure required jars are in `$JENA_BASE/extra` directory.

## UCD Build

This custom build of Fuseki can be made using the local Docker file.  ex:

```
docker build -t docker.io/ucdlib/jena-fuseki-eb:latest .
```

However it is recommended to use Google Cloud Build system.  Now builds can be submitted by using `./submit-build.sh` or by pushing a new tag to the GitHub repository.