# base image to support rpmbuild (packages will be Dist el6)
FROM centos:6

# Copying all contents of rpmbuild repo inside container
COPY . .

# Installing tools needed for rpmbuild , 
# depends on BuildRequires field in specfile, (TODO: take as input & install)
RUN yum install -y -q -e 0 rpm-build rpmdevtools gcc make coreutils python yum-utils

# Setting up node to run our JS file
# Download Node Linux binary
RUN curl --progress-bar --remote-name https://nodejs.org/dist/v12.16.1/node-v12.16.1-linux-x64.tar.xz

# Extract and install
RUN tar --strip-components 1 -xf node-v* -C /usr/local

# Install all dependecies to execute main.js
RUN npm install --production

# Rebuild typescript src/main.ts into lib/main.ts
RUN npm run-script build

# All remaining logic goes inside main.js , 
# where we have access to both tools of this container and 
# contents of git repo at /github/workspace
ENTRYPOINT ["node", "/lib/main.js"]
