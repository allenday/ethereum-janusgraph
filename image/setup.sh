#!/usr/bin/env bash

sudo apt-get install -y zip unzip build-essential git

# Install Java and setup ENV
cd $HOME
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer oracle-java8-set-default

export JAVA_HOME=/usr/lib/jvm/java-8-oracle
echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" | sudo tee -a $HOME/.bash_profile

# Install and setup JanusGraph
cd $HOME
curl -Lko /tmp/janusgraph-0.2.0-hadoop2.zip \
  https://github.com/JanusGraph/janusgraph/releases/download/v0.2.0/janusgraph-0.2.0-hadoop2.zip
unzip -d . /tmp/janusgraph-0.2.0-hadoop2.zip
mv janusgraph-0.2.0-hadoop2 janusgraph
rm /tmp/janusgraph-0.2.0-hadoop2.zip

# Install Miniconda Python 3.5
cd $HOME
curl -Lko /tmp/Miniconda3-latest-Linux-x86_64.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x /tmp/Miniconda3-latest-Linux-x86_64.sh
/tmp/Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/anaconda

export PATH=$HOME/anaconda/bin:$PATH
echo 'export PATH=$HOME/anaconda/bin:$PATH' | sudo tee -a $HOME/.bash_profile

sudo chown -R $USER $HOME/anaconda
sudo chgrp -R $USER $HOME/anaconda

# Setup project
cd $HOME
git clone https://github.com/rjurney/ethereum-janusgraph
cd ethereum-janusgraph
pip install -r requirements.txt

# Get the data, extract a node list from the edge list and then run the data import
bin/get_data.sh
gzip -d data/zrx_export_1.jsonl.gz
bin/extract_nodes.py -e data/zrx_export_1.jsonl -n data/zrx_export_1_nodes.jsonl

# Copy the config files over to simplify starting Janus
cp ethereum-janusgraph/conf/janusgraph-hbase.properties janusgraph/conf/
