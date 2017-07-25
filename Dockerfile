FROM ngty/archlinux-jdk7
MAINTAINER wangdrew

# Install KAIROSDB
RUN cd /opt; \
  curl -L https://github.com/kairosdb/kairosdb/releases/download/v0.9.4/kairosdb-0.9.4-6.tar.gz | \
  tar zxfp -

ADD kairosdb.properties /opt/kairosdb/conf/kairosdb.properties

# Kairos API telnet and jetty ports
EXPOSE 4242 8083

# Set Kairos config vars
#ENV KAIROS_JETTY_PORT 8083
ENV CASSANDRA_HOST_LIST 10.1.2.3:9160

# Copy scripts into container to set kairos config params
ADD config-kairos.sh /usr/bin/config-kairos.sh

RUN mv /etc/pacman.d/gnupg /etc/pacman.d/gnupg.old && pacman-key --init && pacman-key --populate archlinux
RUN yaourt --noconfirm -Sy archlinux-keyring
RUN yaourt --noconfirm -Syyu
RUN yaourt --noconfirm -S netcat

# Copy waiting script
ADD ./start.sh /start.sh
RUN ["chmod", "+x", "/start.sh"]
# Run kairosdb in foreground on boot
CMD ["/start.sh"]
