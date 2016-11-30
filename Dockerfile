#specifying our base docker-image
FROM ubuntu:16.04
MAINTAINER Sahand Hariri sahandha@gmail.com

####Install basics
RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*
RUN apt-get -qq update
RUN apt-get -qq -y install wget && \
apt-get -qq -y install bzip2
RUN apt-get update
RUN sudo apt-get -qq -y install software-properties-common
 
####installing [software-properties-common] so that we can use [apt-add-repository] to add the repository [ppa:webupd8team/java] form which we install Java8
RUN sudo apt-get update
RUN apt-get install software-properties-common -y
RUN apt-add-repository ppa:webupd8team/java -y
RUN apt-get update -y

####install python
RUN apt-get install -y python
RUN sudo apt-get install -y python-pip python-dev build-essential
RUN pip install --upgrade pip
RUN pip install jupyter
ENV PATH=/home/ubuntu/.local/bin:$PATH

 
####automatically agreeing on oracle license agreement that normally pops up while installing java8
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
 
####installing java
RUN apt-get install -y oracle-java8-installer
#####################################################################################

####installing scala
RUN wget http://www.scala-lang.org/files/archive/scala-2.12.0.tgz
RUN tar -xzf scala-2.12.0.tgz
RUN rm scala-2.12.0.tgz
RUN mv scala-2.12.0 /opt/scala
ENV SCALA_HOME=/opt/scala
ENV PATH=$SCALA_HOME/bin:$PATH

####downloading and unpacking Spark 2.0.2
RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz 
RUN tar -xzf spark-2.0.2-bin-hadoop2.7.tgz 
RUN rm spark-2.0.2-bin-hadoop2.7.tgz 
RUN mv spark-2.0.2-bin-hadoop2.7 /opt/spark

EXPOSE 8080 8081 7077 6066 8888
#####################################################################################


RUN apt-get install -y supervisor
 
####copy supervisor configuration files for master and slave nodes (described below)
COPY master.conf /opt/conf/master.conf
COPY slave.conf /opt/conf/slave.conf

RUN mkdir /mnt/nfs
 
#default command: running an interactive spark shell in the local mode
CMD ["/opt/spark/bin/pyspark"]

