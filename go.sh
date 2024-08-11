#!/bin/bash

set -e

JENKINS_HOME=../docker/volumes/jenkins-home

if [ $# -eq 1 ]
  then
    echo "Using analysis-model version $1"
    mvn clean install -Danalysis-model.version=$1 || { echo "Build failed"; exit 1; }
  else
    echo "Using built-in analysis-model version from pom.xml"
    mvn clean install || { echo "Build failed"; exit 1; }
fi

echo "Installing plugin in $JENKINS_HOME"

rm -rf $JENKINS_HOME/plugins/analysis-model*
cp -fv target/analysis-model-api.hpi $JENKINS_HOME/plugins/analysis-model-api.jpi

CURRENT_UID="$(id -u):$(id -g)"
export CURRENT_UID
IS_RUNNING=$(docker compose ps -q jenkins)
if [[ "$IS_RUNNING" != "" ]]; then
    docker compose restart
    echo "Restarting Jenkins (docker compose with user ID ${CURRENT_UID}) ..."
fi
