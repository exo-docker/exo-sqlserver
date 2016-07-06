FROM ubuntu:14.04

WORKDIR /tmp

# VirtualBox
RUN apt-get update && apt-get install -y wget curl 

COPY virtualbox.list /etc/apt/sources.list.d/

RUN wget https://www.virtualbox.org/download/oracle_vbox_2016.asc && \
	apt-key add oracle_vbox_2016.asc && \
	rm oracle_vbox_2016.asc && \
	apt-get update && apt-get install -y build-essential libssl-dev linux-headers-`uname -r` dpkg && \
	mkdir /sqlserver
RUN apt-get install -y virtualbox-4.3

# Vagrant
ENV VAGRANT_VERSION 1.8.4
RUN wget https://releases.hashicorp.com/vagrant/1.8.4/vagrant_${VAGRANT_VERSION}_x86_64.deb && \
	dpkg -i vagrant_${VAGRANT_VERSION}_x86_64.deb && \
	rm vagrant_${VAGRANT_VERSION}_x86_64.deb && \
	vagrant plugin install vagrant-vbguest && \
	vagrant box add msabramo/mssqlserver2014express

# Sqlserver VM
WORKDIR /sqlserver

COPY Vagrantfile init_database-template.cmd /sqlserver/

COPY entrypoint.sh /
RUN chmod u+x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
EXPOSE 3389 1433


