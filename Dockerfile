FROM debian:buster
MAINTAINER Paul Goodall "https://github.com/paul-goodall"

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server sudo

RUN mkdir -p /var/run/sshd
RUN sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g"    /etc/ssh/sshd_config 
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN touch /root/.Xauthority && true

RUN mkdir /root/.ssh

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
RUN ["/bin/bash", "-c", "echo -e 'root\nroot' | passwd root"]

RUN service ssh restart

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
