FROM ubuntu:18.04

ENV COMMAND_CONF /opt/signal.conf
ENV VERSION 0.8.3
WORKDIR /tmp

RUN apt-get update &&  apt-get install -y openjdk-11-jdk
RUN apt-get update &&  apt-get install -y wget tar
 
RUN wget https://github.com/AsamK/signal-cli/releases/download/v"${VERSION}"/signal-cli-"${VERSION}".tar.gz
RUN tar xf signal-cli-"${VERSION}".tar.gz -C /opt
RUN ln -sf /opt/signal-cli-"${VERSION}"/bin/signal-cli /usr/local/bin/

ENV LANG es_CO.UTF-8
ENV LANGUAGE es_CO:es
ENV LC_ALL es_CO.UTF-8
RUN apt-get update &&  apt-get install -y language-pack-es
RUN echo "LANG=es_CO.UTF-8" > /etc/default/locale
RUN ln -sf /usr/share/zoneinfo/America/Bogota /etc/localtime 

COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY src/Signal.pm /opt/Signal.pm
COPY src/cli.pl /usr/bin/cli.pl

RUN chmod +x /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/cli.pl

ENTRYPOINT ["bash", "-x", "/usr/bin/entrypoint.sh"]
CMD ["000-0000"]
