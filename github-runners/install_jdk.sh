#!/bin/sh
# Check if a version argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

VERSION=$1

install_dir="/opt/jdk"
mkdir ${install_dir}

curl -fsSL "https://download.oracle.com/java/$VERSION/latest/jdk-${VERSION}_linux-x64_bin.tar.gz" | tar zx --strip-components=1 -C ${install_dir}

# Add JDK to PATH
echo "export PATH=${INSTALL_DIR}/bin:$PATH" >> /etc/profile.d/jdk.sh
chmod +x /etc/profile.d/jdk.sh

# Verify installation

# Verify installation using Bash
bash -c "source /etc/profile.d/jdk.sh && java -version"

# Verify installation using the dot operator for sourcing
. /etc/profile.d/jdk.sh
java -version