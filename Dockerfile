FROM ubuntu:18.04

ENV COMMAND_CONF /opt/signal.conf
ENV VERSION 0.6.2
WORKDIR /tmp

RUN apt-get update &&  apt-get install -y openjdk-11-jdk
RUN apt-get update &&  apt-get install -y wget tar
 
RUN wget https://github.com/AsamK/signal-cli/releases/download/v"${VERSION}"/signal-cli-"${VERSION}".tar.gz
RUN tar xf signal-cli-"${VERSION}".tar.gz -C /opt
RUN ln -sf /opt/signal-cli-"${VERSION}"/bin/signal-cli /usr/local/bin/

COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY cli.pl /usr/bin/cli.pl

RUN chmod +x /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/cli.pl

ENTRYPOINT ["bash", "-x", "/usr/bin/entrypoint.sh"]
CMD ["000-0000"]