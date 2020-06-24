package org.apache.jena.fuseki.server.eventbus;

import java.util.HashMap;
import java.util.LinkedList;

import org.apache.jena.query.Dataset;
import org.apache.jena.sparql.core.DatasetGraph;
import org.apache.jena.sparql.core.DatasetGraphMonitor;
import org.apache.jena.sparql.core.DatasetImpl;

public class DatasetChangesEventBus {
	
	private static HashMap<Dataset, Dataset> graphs = new HashMap<Dataset, Dataset>();
	private static LinkedList<DatasetEventBusListener> listeners = new LinkedList<DatasetEventBusListener>();
	
	public static Dataset wrap(Dataset ds) {
		if( graphs.containsKey(ds) ) return graphs.get(ds);
		
		DatasetGraph datasetGraphWrapper = new DatasetGraphMonitor(
			ds.asDatasetGraph(), 
			new EventBusDatasetChangesImpl(ds.asDatasetGraph())
		);
		Dataset datasetWrapper = DatasetImpl.wrap(datasetGraphWrapper);
		graphs.put(ds, datasetWrapper);
		
		return datasetWrapper;
	}
	

	public static void listen(DatasetEventBusListener listener) {
		listeners.add(listener);
	}
	
	public static void emit(DatasetChangesEvent e) {
		for( DatasetEventBusListener listener: listeners ) {
			listener.onChange(e);
		}
	}
	
}
