package org.apache.jena.fuseki.server.eventbus;


public interface DatasetEventBusListener {
	public void onChange(DatasetChangesEvent e);
}
