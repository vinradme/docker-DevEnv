FROM centos:7
ARG ssh_prv_key
ARG ssh_pub_key

#install all software
RUN yum update &&
	yum install epel-release -y 
RUN yum install -y \
	git \
	nodejs \
	openssh-server


#make ssh directory and authorize
RUN mkdir /root/.ssh/ && \
	chmod 0700 /root/.ssh && \
	ssh-keyscan github.com > /root/.ssh/known_hosts

# add the keys and set permissions 
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \ 
    echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub

# Clone the app file into the docker container
RUN git clone https://github.com/HealthTap/nextweb.git

WORKDIR /app

COPY package.json /app
RUN npm install

#Remove SSH Keys
RUN rm -rf /root/.ssh/
 
CMD [ "npm", "run", "serve:dev" ]

