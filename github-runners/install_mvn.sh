#!/bin/sh
# Check if a version argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

VERSION=$1


install_dir="/opt/maven"
mkdir ${install_dir}

curl -fsSL "http://www.mirrorservice.org/sites/ftp.apache.org/maven/maven-3/$VERSION/binaries/apache-maven-$VERSION-bin.tar.gz" | tar zx --strip-components=1 -C ${install_dir}


cat << EOF > /etc/profile.d/maven.sh
#!/bin/sh
export MAVEN_HOME=${install_dir}
export M2_HOME=${install_dir}
export M2=${install_dir}/bin
export PATH=${install_dir}/bin:$PATH
EOF

# Verify installation using Bash
bash -c "source /etc/profile.d/maven.sh && mvn -version"
# Verify installation using the dot operator for sourcing
. /etc/profile.d/maven.sh
java -version

echo maven installed to ${install_dir}

