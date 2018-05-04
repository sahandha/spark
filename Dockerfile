FROM python:3.5-slim

MAINTAINER Sahand Hariri sahandha@gmail.com

RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*
RUN apt-get -qq update
RUN apt-get -qq -y install wget && \
apt-get -qq -y install bzip2
RUN apt-get update
RUN sudo apt-get -qq -y install software-properties-common

RUN sudo apt-get install -y python-pip python-dev build-essential \
&& pip install --upgrade pip \
&& pip install numpy scipy 
ENV PATH=/home/ubuntu/.local/bin:$PATH


RUN apt-get update
RUN apt-get install -yq default-jdk

RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz 
RUN tar xvf spark-2.0.2-bin-hadoop2.7.tgz
RUN rm spark-2.0.2-bin-hadoop2.7.tgz
RUN mv spark-2.0.2-bin-hadoop2.7 /opt/spark

WORKDIR /exports/isoforest

ADD log4j.properties /opt/spark/conf/log4j.properties
ADD start-common.sh start-worker start-master /
ADD spark-defaults.conf /opt/spark/conf/spark-defaults.conf

COPY master.conf /opt/conf/master.conf		
COPY slave.conf /opt/conf/slave.conf

ADD start-common.sh start-worker start-master /
ADD spark-defaults.conf /opt/spark/conf/spark-defaults.conf

ENV PYSPARK_PYTHON=/usr/local/bin/python3.5

CMD ["/opt/spark/bin/pyspark"]
