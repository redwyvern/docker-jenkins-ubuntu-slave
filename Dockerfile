FROM docker.artifactory.weedon.org.au/redwyvern/cpp-devenv-base
MAINTAINER Nick Weedon <nick@weedon.org.au>

ARG GIT_USER=Jenkins
ARG GIT_EMAIL=jenkins@weedon.org.au

RUN apt-get clean && apt-get update && apt-get install -y --no-install-recommends \
    git \
    debhelper \
    devscripts \
    fakeroot && \
    apt-get -q autoremove && \
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

# Set user jenkins to the image
RUN useradd -m -d /home/jenkins -s /bin/bash jenkins

USER jenkins
COPY authorized_keys /home/jenkins/.ssh/authorized_keys

RUN git config --global user.name "${GIT_USER}" && \
    git config --global user.email "${GIT_EMAIL}"

USER root

COPY ./usr /usr
COPY settings.xml /home/jenkins/.m2/settings.xml

# Sencha permissions need to allow the jenkins user to execute binaries such as phantomjs for building
RUN 	chown -R jenkins.jenkins /home/jenkins

# Standard SSH port
EXPOSE 22

# Default command
CMD ["/usr/sbin/sshd", "-D"]

