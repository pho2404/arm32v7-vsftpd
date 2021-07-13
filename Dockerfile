# Python Base Image from https://hub.docker.com/r/arm32v7/python/

#docker build  --build-arg FTPUSER=user --build-arg FTPPASSWORD=password --tag "arm32v7/vsftpd:latest" . 

FROM arm32v7/python:latest

ARG FTPUSER
ARG FTPPASSWORD

RUN apt-get update
RUN apt-get install apt-utils -y
RUN apt-get install vsftpd -y

COPY vsftpd.conf /etc/vsftpd.conf
COPY user_list /etc/vsftpd/user_list
COPY chroot_list /etc/vsftpd/chroot_list

#RUN mkdir /home/ftp
#RUN mkdir /home/ftp/files
RUN mkdir /var/run/vsftpd
#RUN chmod a-w /home/ftp


RUN adduser ${FTPUSER} --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
RUN echo "${FTPUSER}:${FTPPASSWORD}" | chpasswd
RUN echo "${FTPUSER}" | tee -a /etc/vsftpd/user_list

RUN mkdir -p /home/${FTPUSER}/ftp/upload
RUN chmod 550 /home/${FTPUSER}/ftp
RUN chmod 750 /home/${FTPUSER}/ftp/upload
RUN chown -R ${FTPUSER}: /home/${FTPUSER}/ftp

CMD vsftpd