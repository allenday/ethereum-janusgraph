#!/usr/bin/env bash


GET_CMD='gsutil cp gs://ether-bigquery/users/rjurney/zrx_export_1.jsonl.gz data/'
echo $GET_CMD
$GET_CMD
