#!/bin/bash
set -e

renderDockerfile () {
  mkdir -p $VERSION
  cp -a Dockerfile.template $VERSION/Dockerfile
  cp -a files/requirements.txt.tpl $VERSION/requirements.txt
  cp -a scripts/entrypoint.sh $VERSION/entrypoint.sh
  sed -i.bk "s/PYTHON_VERSION/$PYTHON_VERSION/g" $VERSION/Dockerfile
  sed -i.bk "s/DEVPI_VERSION/$VERSION/g" $VERSION/requirements.txt
}

if [ -z $VERSION -o -z $PYTHON_VERSION ] ; then
  echo "Something seriously screwed within TravisCI. Version var not set. Returning error code..."
  exit -1
fi

renderDockerfile

cd $VERSION

docker build -t "gini/devpi:$VERSION" .

cd -
