#! /bin/bash

SCRIPT_DIR=`pwd`
DIR=/tmp/tmp-$(uuidgen | cut -d "-" -f5)-gitops

# setup tmp working directory
mkdir $DIR
cd $DIR

# Create temporary kustomize project
cp $SCRIPT_DIR/../kustom-kafka-sizing/kafka-sizing/application.properties .
echo 'configMapGenerator:
- name: kafka-sizing
  env: application.properties' > kustomization.yaml



# Execute helm chart and save to specified file
kustomize build .

# remove tmp working directory
cd $DIR
rm -rf *
cd ..
rmdir $DIR


exit 0