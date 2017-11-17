FROM centos:7
ARG ssh_prv_key
ARG ssh_pub_key


CMD "sh" "-c" "echo nameserver 8.8.8.8 > /etc/resolv.conf"


#install all software
RUN yum clean all
RUN yum -y update 
RUN yum install -y git 
RUN yum install -y epel-release
RUN yum install -y nodejs 
RUN yum install -y openssh-server


#make ssh directory and authorize
RUN mkdir /root/.ssh/ && \
	chmod 0700 /root/.ssh && \
	ssh-keyscan github.com > /root/.ssh/known_hosts

# add the keys and set permissions 
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \ 
    echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub

# Adding the ssh-key option
RUN echo "Host github.com-*" >> ~/.ssh/config
RUN echo "HostName github.com" >> ~/.ssh/config
RUN echo "IdentityFile ~/.ssh/id_rsa" >> ~/.ssh/config

# Clone the app file into the docker container
RUN git clone git@github.com:HealthTap/nextweb.git



#COPY package.json /app
RUN cd nextweb; npm install

#Remove SSH Keys
RUN rm -rf /root/.ssh/
 
CMD [ "npm", "run", "serve:dev" ]

