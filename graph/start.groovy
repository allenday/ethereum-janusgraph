// Setup our database on top of cassandra/elasticsearch
graph = JanusGraphFactory.open("conf/janusgraph-hbase.properties")

g = graph.traversal()
