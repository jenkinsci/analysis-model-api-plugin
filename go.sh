#!/bin/bash

if [[ -z "$JENKINS_HOME" ]]; then
    JENKINS_HOME=../jenkins-home
    echo "JENKINS_HOME is not defined, using $JENKINS_HOME"
fi

mvn -o clean install || { echo "Build failed"; exit 1; }

echo "Installing plugin in JENKINS_HOME"
rm -rf $JENKINS_HOME/plugins/analysis-model*
cp -fv target/analysis-model-api.hpi $JENKINS_HOME/plugins/analysis-model-api.jpi

IS_RUNNING=`docker-compose ps -q jenkins`
if [[ "$IS_RUNNING" != "" ]]; then
    echo "Restarting Jenkins..."
    docker-compose restart
fi


