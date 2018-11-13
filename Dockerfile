FROM centos:7

MAINTAINER duanqz duanqz@gmail.com

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh \
  && yum install -y git golang openssl \
  && git clone https://github.com/inconshreveable/ngrok.git ngrok-backend \
  && cd ngrok-backend \


EXPOSE 80/tcp 443/tcp 8081/tcp 8082/tcp 9527/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]