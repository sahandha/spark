FROM continuumio/miniconda3
MAINTAINER Sahand Hariri sahandha@gmail.com

ENV hadoop_ver 2.6.1
ENV spark_ver 2.0.2

RUN apt-get update && apt-get install -yq --no-install-recommends \
    curl \
    unzip \
    software-properties-common \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*
#Install java
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

RUN apt-get update
RUN apt-get install -yq default-jdk

# Get Hadoop from US Apache mirror and extract just the native
# libs. (Until we care about running HDFS with these containers, this
# is all we need.)

RUN mkdir -p /opt 
#&& cd /opt \
#&& curl http://www.us.apache.org/dist/hadoop/common/hadoop-${hadoop_ver}/hadoop-${hadoop_ver}.tar.gz | tar -zx hadoop-${hadoop_ver}/lib/native \
#&& ln -s hadoop-${hadoop_ver} hadoop \
#&& echo Hadoop ${hadoop_ver} native libraries installed in /opt/hadoop/lib/native


# Get Spark from US Apache mirror.
RUN cd /opt \
&& curl http://www.us.apache.org/dist/spark/spark-${spark_ver}/spark-${spark_ver}-bin-hadoop2.6.tgz | tar -zx \
&& ln -s spark-${spark_ver}-bin-hadoop2.6 spark 
#&& rm -rd /opt/spark-${spark_ver}-bin-hadoop2.6.tgz


# if numpy is installed on a driver it needs to be installed on all
# workers, so install it everywhere
RUN pip install numpy scipy
RUN rm -rf /var/lib/apt/lists/*

ADD start-common.sh start-worker start-master /
ADD spark-defaults.conf /opt/spark/conf/spark-defaults.conf

ENV PATH $PATH:/opt/spark/bin
