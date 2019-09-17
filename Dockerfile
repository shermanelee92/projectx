FROM rastasheep/ubuntu-sshd

RUN apt-get update
RUN apt-get install openjdk-11* -y
RUN apt-get install vim -y
WORKDIR /usr/local
RUN mkdir hadoop
RUN mkdir spark
