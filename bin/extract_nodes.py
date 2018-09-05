#!/usr/bin/env python

import sys, os
import argparse
import json
from frozendict import frozendict
import gzip

parser = argparse.ArgumentParser(
  description='This is a script to extract an Ethereum node list from an Ethereum edge list.',
  epilog='Example usage: ./extract_nodes.py -e data/zrx_export_one.jsonl -n data/zrx_export_one_nodes.jsonl'
)
parser.add_argument('-e', '--edges', help="Path to the edges file", required=True)
parser.add_argument('-n', '--nodes', help="Path to the output nodes file", required=True)
args = parser.parse_args()

# Load and parse the data
open_func = None
if args.edges.endswith(".gz"):
  open_func = gzip.open
else:
  open_func = open

f = open_func(args.edges)
records = []
for line in f:
  record = frozendict(json.loads(line))
  records.append(record)

# Compute the distinct nodes
nodes = set()
for record in records:
  tx_source = record['tx_source']
  tx_target = record['tx_target']

  nodes.add(frozendict({"tx_id": tx_source}))
  nodes.add(frozendict({"tx_id": tx_target}))

total_nodes = len(list(nodes))
print("Total nodes extracted: {:,}".format(total_nodes))

nodes_f = open(args.nodes, "w")
for node in list(nodes):
  node_json = json.dumps(dict(node))
  nodes_f.write(node_json + "\n")
nodes_f.close()
