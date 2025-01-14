#!/bin/bash
# Check if a version argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

VERSION=$1

VERSION="3.9.9"
INSTALL_DIR="/opt/maven"
mkdir $INSTALL_DIR

curl -fsSL "http://www.mirrorservice.org/sites/ftp.apache.org/maven/maven-3/$VERSION/binaries/apache-maven-$VERSION-bin.tar.gz" | tar zx --strip-components=1 -C $INSTALL_DIR

MAVEN_PROFILE="/etc/profile.d/maven.sh"
echo 'export MAVEN_HOME=$INSTALL_DIR' >> $MAVEN_PROFILE
echo 'export M2_HOME=$INSTALL_DIR' >> $MAVEN_PROFILE
echo 'export M2=$INSTALL_DIR/bin' >> $MAVEN_PROFILE
echo 'export PATH=$INSTALL_DIR/bin:$PATH' >> $MAVEN_PROFILE

chmod +x $MAVEN_PROFILE
