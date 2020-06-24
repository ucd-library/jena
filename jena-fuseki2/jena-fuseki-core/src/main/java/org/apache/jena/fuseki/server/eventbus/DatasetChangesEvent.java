package org.apache.jena.fuseki.server.eventbus;

import org.apache.jena.graph.Node;
import org.apache.jena.sparql.core.DatasetGraph;
import org.apache.jena.sparql.core.QuadAction;

public class DatasetChangesEvent {
	private String event;
	private QuadAction qaction;
	private Node g;
	private Node s;
	private Node p;
	private Node o;
	private DatasetGraph datasetGraph;
	
	DatasetChangesEvent(String event, DatasetGraph datasetGraph) {
		this.event = event;
		this.datasetGraph = datasetGraph;
	}
	
	DatasetChangesEvent(String event, DatasetGraph datasetGraph, QuadAction qaction, Node g, Node s, Node p, Node o) {
		this.event = event;
		this.datasetGraph = datasetGraph;
		this.qaction = qaction;
		this.g = g;
		this.s = s;
		this.p = p;
		this.o = o;
	}
	
	public String getEvent() {
		return event;
	}

	public QuadAction getQaction() {
		return qaction;
	}

	public Node getG() {
		return g;
	}
	
	public Node getS() {
		return s;
	}
	
	public Node getP() {
		return p;
	}

	public Node getO() {
		return o;
	}
	
	public DatasetGraph getDatasetGraph() {
		return datasetGraph;
	}
}
