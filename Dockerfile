FROM ubuntu:14.04
MAINTAINER Laitkor Infosolutions Pvt Ltd <arvind.rawat@laitkor.com>

RUN export DEBIAN_FRONTEND='noninteractive' && \
              apt-get update -qq && \
              apt-get -qqy --no-install-recommends install curl netcat  build-essential git openssh-server nodejs nfs-kernel-server portmap
RUN curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/* /tmp/*

######ssh install###
RUN mkdir /var/run/sshd
RUN echo 'root:m2n1shlko' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
#####

WORKDIR /root
RUN curl -k -O https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz
RUN tar -xvf go1.6.linux-amd64.tar.gz
RUN echo "127.0.0.1 dockerhost" >> /etc/hosts

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
COPY bashrc /root/.bashrc
RUN source /root/.bashrc

WORKDIR /root/go
## mount the /root/go/src from the host 
RUN mkdir -p src/github.com/mattermost
WORKDIR /root/go/src/github.com/mattermost

VOLUME /root/go/src/github.com/mattermost
RUN rm /root/go1.6.linux-amd64.tar.gz
COPY config.template.json /root/config.template.json
COPY Makefile /root/
COPY git.sh /root/
RUN chmod +x /root/git.sh

COPY http1.go /root/go/src
COPY docker-entry.sh /root
RUN chmod +x /root/docker-entry.sh
ENTRYPOINT ["/root/docker-entry.sh"]
EXPOSE 8080
EXPOSE 8065
EXPOSE 22
