// Setup our database on top of cassandra/elasticsearch
graph = JanusGraphFactory.open("conf/janusgraph-hbase.properties")

graph.close()

org.janusgraph.core.util.JanusGraphCleanup.clear(graph)
