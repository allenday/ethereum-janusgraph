import java.text.NumberFormat;
import java.util.Date;

// Setup our database on top of cassandra/elasticsearch
graph = JanusGraphFactory.open("conf/janusgraph-hbase.properties")

// Get a graph traverser
g = graph.traversal()

// Setup JSON Reading of data
jsonSlurper = new JsonSlurper()

// Add nodes to graph
nodesFilename = "../ethereum-janusgraph/data/zrx_export_1_nodes.jsonl"
nodesReader = new BufferedReader(new FileReader(nodesFilename));

i = 0
while((json = nodesReader.readLine()) != null)
{
  document = jsonSlurper.parseText(json)

  v = graph.addVertex('node')
  v.property("hash", document.tx_id)

  if(i % 1000 == 0) {
    graph.tx().commit()
    str = NumberFormat.getIntegerInstance().format(i)
    println(str + "N")
  }
  i++
}

// Commit the nodes
graph.tx().commit()

// Create transfer edges between nodes
edgesFilename = "../ethereum-janusgraph/data/zrx_export_1.jsonl"
edgesReader = new BufferedReader(new FileReader(edgesFilename))

i = 0
while((json = edgesReader.readLine()) != null)
{
  document = jsonSlurper.parseText(json)

  // Fetch the two nodes by hash
  node1 = g.V().has('hash', document.tx_source).next()
  node2 = g.V().has('hash', document.tx_target).next()

  edge = node1.addEdge("transfer", node2)
  edge.property("hash", document.tx_hash)
  edge.property("edge_timestamp", Date.parse("yyyy-MM-dd HH:mm:ss Z", document.timestamp))
  edge.property("token_val", document.token)
  edge.property("tx_value", document.tx_value)

  if(i % 1000 == 0) {
    graph.tx().commit()
    str = NumberFormat.getIntegerInstance().format(i)
    println(str + "E")
  }
  i++
}

// Setup sessions so we can remember variables
:remote connect tinkerpop.server conf/remote.yaml session

nodeCount = g.V().hasLabel('node').count().next()
println(nodeCount)
assert(nodeCount == 105529)

edgeCount = g.E().hasLabel('transfer').count()
println(edgeCount)
assert(edgeCount == 241793)

// Close graph
graph.close()

