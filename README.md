# limetext-docker
Dockerfile for development on https://github.com/limetext/lime

Based on the ubuntu 14.04 image. It sets up a new user called 'me' with UID and GID 1000, corresponding to my user on the host so that there will be no trouble with file permissions.

###1. Build the Docker image

	$ sudo docker build -t=jobe0900/limebuntu:1 .

Build an image from a Dockerfile in current directory (the last `.`). The image is called `jobe0900/limebuntu`, tagged with `1` as a version number.

###2. Create a directory for the limetext source

	$ mkdir code

We need to do this on the host so that the directory gets the right permissions
	
###3. Create an alias for simplifying running the box

(I name my "box" `limebuntu`, but it can be called anything.)

	$ echo "alias limebuntu='sudo docker run -it -v \`pwd\`/code:/home/me --rm jobe0900/limebuntu:1'" >> ~/.bashrc
	$ . ~/.bashrc

The flags for the Docker `run` command is

- `-i`	interactive,
- `-t`	tty,
- `-v`	volumes to sync (`$PWD/code` on host with `/home/me` on the container),
- `--rm`	remove container after use.

This creates a throw away container that is removed after use, but since folders are synced between container and host, changes to those files are persisted.

To start an interactive session with the container (log out with `exit`):

    $ limebuntu
    
Or to run an one off command:

    $ limebuntu /bin/bash -c "ls -la"
	
###4. Fetch the source
    
	$ limebuntu go get -u github.com/limetext/lime/frontend/...
	
###5. Update the submodules

	$ limebuntu /bin/bash -c "cd \$GOPATH/src/github.com/limetext/lime/ && git submodule update --init"

###6. Build the frontends

	$ limebuntu /bin/bash -c "cd \$GOPATH/src/github.com/limetext/lime/frontend/termbox && go build"
	$ limebuntu /bin/bash -c "cd \$GOPATH/src/github.com/limetext/lime/frontend/qml && go build"
	$ limebuntu /bin/bash -c "cd \$GOPATH/src/github.com/limetext/lime/frontend/html && go build"
	
###7. Run tests

**Backend**: Tests fail...

	$ limebuntu go test github.com/limetext/lime/backend/...
	...
	FAIL	github.com/limetext/lime/backend/watch	0.010s

**Frontend**: Tests pass

	$ limebuntu go test github.com/limetext/lime/frontend/...
	?   	github.com/limetext/lime/frontend	[no test files]
	ok  	github.com/limetext/lime/frontend/html	0.021s
	ok  	github.com/limetext/lime/frontend/qml	0.189s
	ok  	github.com/limetext/lime/frontend/termbox	0.039s


###8. Run the frontends on the host

**Termbox**: Ctrl + Q to quit the `termbox` frontend

	$ cd code/src/github.com/limetext/lime/frontend/termbox/
	$ ./termbox main.go

**QML**: Ordinary GUI (works with some flickering)
	
	$ cd ../qml
	$ ./qml

**HTML**: Browse to `http://localhost:8080` . Ctrl + C to quit server
	
	$ cd ../html
	$ ./html
