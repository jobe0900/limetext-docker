FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

# update the packages
RUN apt-get update

# wget needed for fetching oniguruma and golang
RUN apt-get install wget -y

# python needed
RUN apt-get install python-software-properties software-properties-common -y
RUN echo 'yes' | add-apt-repository ppa:fkrull/deadsnakes
RUN apt-get update && \
	apt-get install \ 
	python3.4 \ 
	python3.4-dev \ 
	-y

# install other needed tools
RUN apt-get install \ 
	cmake \ 
	make \ 
	mercurial \ 
	git \ 
	build-essential \ 
	libonig2 \ 
	libonig-dev \
	pkg-config \ 
	-y
	
# install qt related tools for the frontend
RUN apt-get install \
	g++ \
	libqt5qml-graphicaleffects \
	libqt5opengl5-dev \
	qtbase5-private-dev \
	qtdeclarative5-dev \
	qtdeclarative5-controls-plugin \
	qtdeclarative5-quicklayouts-plugin \
	qtdeclarative5-qtquick2-plugin \
	qtdeclarative5-dialogs-plugin \
	qtdeclarative5-window-plugin \
	-y

# patch oniguruma
WORKDIR /usr/lib/pkgconfig
RUN wget https://raw.githubusercontent.com/limetext/rubex/master/oniguruma.pc

# install go
WORKDIR /tmp
RUN wget https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz && \ 
	tar -C /usr/local -xvzf go1.4.2.linux-amd64.tar.gz && \ 
	bash -c "echo 'export PATH=\$PATH:/usr/local/go/bin' >> /etc/profile" && \ 
	bash -c "source /etc/profile"
	
# clean up after installations
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# create a new user 'me'
RUN mkdir -p /home/me && \ 
	bash -c "echo 'me:x:1000:1000:Me,,,:/home/me:/bin/bash' >> /etc/passwd" && \ 
	bash -c "echo 'me:x:1000:1000:' >> /etc/group" && \ 
	bash -c "echo 'me ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/me" && \ 
	chmod 0440 /etc/sudoers.d/me && \ 
	chown me:me -R /home/me && \ 
	chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

# set up the new user
USER me
WORKDIR /home/me
ENV HOME /home/me
ENV GOPATH /home/me
ENV PATH $PATH:/usr/local/go/bin

# prepare for limetext
ENV PKG_CONFIG_PATH $GOPATH/src/github.com/limetext/rubex

# log into bash as default
CMD ["/bin/bash"]
