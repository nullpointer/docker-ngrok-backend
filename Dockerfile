FROM centos:latest

COPY entrypoint.sh /sbin/entrypoint.sh

COPY epel-release-latest-7.noarch.rpm epel-release-latest-7.noarch.rpm
RUN rpm -ivh epel-release-latest-7.noarch.rpm

RUN chmod 755 /sbin/entrypoint.sh
RUN yum install -y golang git openssl
RUN git clone https://github.com/inconshreveable/ngrok.git ngrok-backend

EXPOSE 80/tcp 443/tcp 9525/tcp 9526/tcp 9527/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]
