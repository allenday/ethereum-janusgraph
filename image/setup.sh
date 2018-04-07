#!/usr/bin/env bash

sudo apt-get install -y zip unzip build-essential

# Install and setup JanusGraph
cd $HOME
curl -Lko /tmp/janusgraph-0.2.0-hadoop2.zip \
  https://github.com/JanusGraph/janusgraph/releases/download/v0.2.0/janusgraph-0.2.0-hadoop2.zip
unzip -d . /tmp/janusgraph-0.2.0-hadoop2.zip
mv janusgraph-0.2.0-hadoop2 janusgraph
rm /tmp/janusgraph-0.2.0-hadoop2.zip

# Install Miniconda Python 3.5
curl -Lko /tmp/Miniconda3-latest-Linux-x86_64.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x /tmp/Miniconda3-latest-Linux-x86_64.sh
/tmp/Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/anaconda

export PATH=$HOME/anaconda/bin:$PATH
echo 'export PATH=$HOME/anaconda/bin:$PATH' | sudo tee -a $HOME/.bash_profile

sudo chown -R $USER $HOME/anaconda
sudo chgrp -R $USER $HOME/anaconda

pip install -r requirements.txt
