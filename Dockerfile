FROM continuumio/miniconda

MAINTAINER Sahand Hariri sahandha@gmail.com

RUN apt-get update && apt-get install -yq --no-install-recommends \
    wget \
    vim \
    unzip \
    python-dev \
    software-properties-common \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#Install java
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

RUN apt-get update
RUN apt-get install -yq default-jdk

RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz 
RUN tar xvf spark-2.0.2-bin-hadoop2.7.tgz
RUN rm spark-2.0.2-bin-hadoop2.7.tgz
RUN mv spark-2.0.2-bin-hadoop2.7 /opt/spark

EXPOSE 8080 8081 7077 6066 8888

RUN apt-get install -y supervisor
 
####copy supervisor configuration files for master and slave nodes (described below)
COPY master.conf /opt/conf/master.conf
COPY slave.conf /opt/conf/slave.conf

RUN mkdir -p /external/spark-jupyter
WORKDIR /external/spark-jupyter

#default command: running an interactive spark shell in the local mode
CMD ["/opt/spark/bin/pyspark"]

