# limetext-docker
Dockerfile for development on https://github.com/limetext/lime
Based on the ubuntu 14.04 image.

###1. Build the Docker image

	$ sudo docker build -t=jobe0900/limebuntu:1 .

Build an image from a Dockerfile in current directory (the last `.`). The image is called `jobe0900/limebuntu`, tagged with `1` as a version number.
	
###2. Create an alias for simplifying running the box

(I name my box `limebuntu`, but it can be called anything.)

	$ echo "alias limebuntu='sudo docker run -it -v \`pwd\`/code:/home/me --rm jobe0900/limebuntu:1'" >> ~/.bashrc
	$ . ~/.bashrc

The flags for the Docker `run` command is

`-i`	interactive,
`-t`	tty,
`-v`	volumes to sync on host:container,
`--rm`	remove container after use.
	
###3. Create a directory for the limetext source

	$ mkdir code

We need to do this on the host so that the directory gets the right permissions
	
###4. Fetch the source
    
	$ limebuntu go get -u github.com/limetext/lime/frontend/...
	
###5. Update the submodules

	$ limebuntu /bin/bash -c "cd \$GOPATH/src/github.com/limetext/lime/ && git submodule update --init"

###6. Build the frontends

	$ limebuntu /bin/bash -c "cd \$GOPATH/src/github.com/limetext/lime/frontend/termbox && go build"
	$ limebuntu /bin/bash -c "cd \$GOPATH/src/github.com/limetext/lime/frontend/qml && go build"
	$ limebuntu /bin/bash -c "cd \$GOPATH/src/github.com/limetext/lime/frontend/html && go build"
	
###7. Run tests
	
	$ limebuntu go test github.com/limetext/lime/backend/...
	...
	FAIL	github.com/limetext/lime/backend/watch	0.010s

The test for the backend failed...

	$ limebuntu go test github.com/limetext/lime/frontend/...
	?   	github.com/limetext/lime/frontend	[no test files]
	ok  	github.com/limetext/lime/frontend/html	0.021s
	ok  	github.com/limetext/lime/frontend/qml	0.189s
	ok  	github.com/limetext/lime/frontend/termbox	0.039s

The frontend tests passed

###8. Run the frontends on the host

	$ cd code/src/github.com/limetext/lime/frontend/termbox/
	$ ./termbox main.go

Ctrl + Q to quit the `termbox` frontend
	
	$ cd ../qml
	$ ./qml

This also works, with some flickering
	
	$ cd ../html
	$ ./html

Browse to `http://localhost:8080`
Ctrl + C to quit server
