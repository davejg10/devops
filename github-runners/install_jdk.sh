#!/bin/sh
# Check if a version argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

VERSION=$1

install_dir="/opt/jdk"
mkdir ${install_dir}

curl -fsSL "https://download.oracle.com/java/$VERSION/latest/jdk-${VERSION}_linux-x64_bin.tar.gz" | tar -zxf --strip-components=1 -C ${install_dir}

# Add JDK to PATH
echo "export PATH=${INSTALL_DIR}/bin:$PATH" >> /etc/profile.d/jdk.sh
chmod +x /etc/profile.d/jdk.sh

# Verify installation
source /etc/profile.d/jdk.sh
java -version