#
# Ghost Dockerfile
#
# https://github.com/dockerfile/ghost
#

# Pull base image.
FROM node:6-alpine

# Install Ghost
RUN \
  cd /tmp && \
  apk update && \
  apk add curl unzip bash git sudo && \
  curl https://github.com/TryGhost/Ghost/releases/download/0.11.4/Ghost-0.11.4.zip -L -o ghost.zip && \
  mkdir /ghost && \
  unzip ghost.zip -d /ghost && \
  rm -f ghost.zip && \
  cd /ghost && \
  npm install --production && \
  sed -e 's/127.0.0.1/0.0.0.0/' -e 's/2368/8080/' /ghost/config.example.js > /ghost/config.js && \
  adduser -S ghost -h /ghost

# Add files.
ADD start.bash /ghost-start

# Set environment variables.
ENV NODE_ENV production

# Define mountable directories.
VOLUME ["/data", "/ghost-override"]

# Define working directory.
WORKDIR /ghost

# Define default command.
CMD ["bash", "/ghost-start"]

# Expose ports.
EXPOSE 8080
