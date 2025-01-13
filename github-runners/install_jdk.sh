F
# Check if a version argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

VERSION=$1

INSTALL_DIR="/opt/jdk"
mkdir $INSTALL_DIR

curl -fsSL "https://download.oracle.com/java/$VERSION/latest/jdk-${VERSION}_linux-x64_bin.tar.gz" | tar zx --strip-components=1 -C $INSTALL_DIR

# Add JDK to PATH
echo "export JAVA_HOME=$INSTALL_DIR" >> /etc/profile.d/jdk.sh
echo "export PATH=$INSTALL_DIR/bin:$PATH" >> /etc/profile.d/jdk.sh
chmod +x /etc/profile.d/jdk.sh

# Verify installation using the dot operator for sourcing
. /etc/profile.d/jdk.sh
java -version
