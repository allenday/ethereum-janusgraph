// Setup our database on top of cassandra/elasticsearch
graph = JanusGraphFactory.open("conf/janusgraph-hbase.properties")

g = graph.traversal()

// Setup our graph schema
mgmt = graph.openManagement()

// Vertex labels
node = mgmt.makeVertexLabel('node').make()

// Identifier node properties
hash = mgmt.makePropertyKey('hash').dataType(String.class).cardinality(Cardinality.SINGLE).make()
edgeTimestamp = mgmt.makePropertyKey('edge_timestamp').dataType(Date.class).make()
token = mgmt.makePropertyKey('token_val').dataType(String.class).cardinality(Cardinality.SINGLE).make() // 'token' is reserved
tx_value = mgmt.makePropertyKey('tx_value').dataType(Float.class).make()

// Indexes
mgmt.buildIndex('byHashUnique', Vertex.class).addKey(hash).unique().buildCompositeIndex()

// Relationships
transfers = mgmt.makeEdgeLabel('transfer').multiplicity(SIMPLE).make()

// Commit changes
mgmt.commit()

// Close graph
graph.close()
