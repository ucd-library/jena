package org.apache.jena.fuseki.server.eventbus;

import org.apache.jena.graph.Node;
import org.apache.jena.sparql.core.DatasetChanges;
import org.apache.jena.sparql.core.DatasetGraph;
import org.apache.jena.sparql.core.QuadAction;

public class EventBusDatasetChangesImpl implements DatasetChanges {
	
	private DatasetGraph ds;
	
	EventBusDatasetChangesImpl(DatasetGraph ds) {
		super();
		this.ds = ds;
	}

	@Override
	public void start() {
		DatasetChangesEventBus.emit(new DatasetChangesEvent("start", this.ds));
	}

	@Override
	public void change(QuadAction qaction, Node g, Node s, Node p, Node o) {
		DatasetChangesEventBus.emit(new DatasetChangesEvent("change", this.ds, qaction, g, s, p, o));
	}

	@Override
	public void finish() {
		DatasetChangesEventBus.emit(new DatasetChangesEvent("start", this.ds));
	}

	@Override
	public void reset() {
		DatasetChangesEventBus.emit(new DatasetChangesEvent("start", this.ds));
	}
}
