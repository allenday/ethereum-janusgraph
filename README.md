# ethereum-janusgraph

This is the code repository for the Google and friends work with Ethereum blockchain data in BigQuery/JanusGraph/BigTable.

## Prerequisites

* Ask Allen Day for access to [Asana](https://app.asana.com/0/601215071200863/list) to coordiante tasks
* Share your Google account with Allen to gain access to the [Google Cloud Project 'ether-bigquery'](https://console.cloud.google.com/home?project=ether-bigquery)

## Resources

The JanusGraph instance is called [`ethereum-janusgraph-2`](https://console.cloud.google.com/compute/instancesDetail/zones/us-east1-b/instances/ethereum-janusgraph-2?project=ether-bigquery&graph=GCE_CPU&duration=PT1H). You can ssh into it using the GCP console.

## User Setup

Once you ssh into `ethereum-janusgraph-2`, you can get your own copy of JanusGraph with the BigTable configuration file via:

```
cp -R /home/russell_jurney/janusgraph ./
```

Now you can start JanusGraph with the following command:

```
janusgraph/bin/gremlin.sh
```

Once it starts, run the commands in the file [graph/start.groovy](graph/start.groovy): 

```
// Setup our database on top of cassandra/elasticsearch
graph = JanusGraphFactory.open("conf/janusgraph-hbase.properties")

g = graph.traversal()
```

Now you may query the graph using Gremlin queries. To learn Gremlin, check out the free book [Practical Gremlin](http://kelvinlawrence.net/book/Gremlin-Graph-Guide.html).

## Data Model

The data model is described in [graph/setup_janus.groovy](graph/setup_janus.groovy). The data was loaded via [graph/load_janus.groovy](graph/load_janus.groovy).

## Host Image Setup

If you want to start your own JanusGraph server, see the script [image/setup.sh](image/setup.sh), which will automate the image setup.
