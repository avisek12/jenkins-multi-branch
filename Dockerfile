#download base image
FROM quay.io/centos/centos:stream9

#USER root

#install packages
RUN yum install -y httpd
RUN \
    echo "1" >> /var/www/html/demo.txt &&\
    echo "2" >> /var/www/html/demo.txt &&\
    echo "3" >> /var/www/html/demo.txt &&\
    echo "4" >> /var/www/html/demo.txt 

#run http service at foreground
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"] 

#copy file inside container local file
COPY index.html /var/www/html/index.html

#download the files from URL and save it inside container 
ADD https://raw.githubusercontent.com/docker-library/hello-world/master/hello.c /tmp/sample.txt

#Create Environments inside docker
ENV devops "I am Partha"
ENV newvar=amit



