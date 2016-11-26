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
 
####automatically agreeing on oracle license agreement that normally pops up while installing java8
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
 
####installing java
RUN apt-get install -y oracle-java8-installer
#####################################################################################
####downloading and unpacking Spark 1.6.1 [prebuilt for Hadoop 2.6+ and scala 2.10]
RUN wget http://spark-dist.paas.uninett.no/spark-2.0.1-bin-uninett-spark.tgz
RUN tar -xzf spark-2.0.1-bin-uninett-spark.tgz
RUN rm spark-2.0.1-bin-uninett-spark.tgz
####moving the spark root folder to /opt/spark
RUN mv spark-2.0.1-bin-uninett-spark /opt/spark

ENV SPARK_MASTER_HOST master 
####exposing port 8080 so we can later access the Spark master UI; to verify spark is running …etc.
EXPOSE 8080 8081 7077 8888
#####################################################################################


RUN apt-get install -y supervisor
 
####copy supervisor configuration files for master and slave nodes (described below)
COPY master.conf /opt/conf/master.conf
COPY slave.conf /opt/conf/slave.conf

RUN mkdir /mnt/nfs
 
#default command: running an interactive spark shell in the local mode
CMD ["/opt/spark/bin/pyspark", "--master", "local[*]"]

