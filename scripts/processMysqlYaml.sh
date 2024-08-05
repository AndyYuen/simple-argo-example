#! /bin/bash

SCRIPT_DIR=`pwd`
DIR=/tmp/tmp-$(uuidgen | cut -d "-" -f5)-gitops

# setup tmp working directory
mkdir $DIR
cd $DIR
echo "initSql: https://raw.githubusercontent.com/andyyuen/kafka-sizing/master/src/main/resources/schema-mysql.sql" > values.yaml

# Create temporary helm chart for templating the mysql.yaml file
mkdir templates
cp $SCRIPT_DIR/../helm-kafka-sizing/templates/mysql.yaml templates/
cp $SCRIPT_DIR/../helm-kafka-sizing/templates/_mysql_hook.yaml templates/
cp $SCRIPT_DIR/../helm-kafka-sizing/Chart.yaml .

# Execute helm chart and save to specified file
helm template . --values values.yaml

# remove tmp working directory
cd $DIR
rm -rf *
cd ..
rmdir $DIR

exit 0