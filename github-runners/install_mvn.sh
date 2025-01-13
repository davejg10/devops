!/bin/bash
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

cat << EOF > /etc/profile.d/maven.sh
#!/bin/bash
export MAVEN_HOME=$INSTALL_DIR
export M2_HOME=$INSTALL_DIR
export M2=$INSTALL_DIR/bin
export PATH=$INSTALL_DIR/bin:$PATH
EOF

chmod +x /etc/profile.d/maven.sh

# Verify installation using the dot operator for sourcing
. /etc/profile.d/maven.sh
mvn -version

echo maven installed to $INSTALL_DIR

