# Running Android apps using Docker and ARC Welder

This tutorial will allow you to run multiple Android Apps using ARC Welder inside individual Docker containers.

 * Setup

   Use a Docker image that already has Chrome installed.

   https://registry.hub.docker.com/u/jess/chrome/

```
docker pull jess/chrome
```

 * Start a container

```
docker run -it \
	--net host \
	--cpuset-cpus 0 \ 
	--memory 512mb \ # max memory it can use
	-v /tmp/.X11-unix:/tmp/.X11-unix \ # mount the X11 socket
	-e DISPLAY=unix$DISPLAY \
	-v $HOME/Downloads:/root/Downloads \
	--device /dev/snd \ # so we have sound
  	--entrypoint /bin/bash \
	--name chrome \
	jess/chrome:latest

```

 * Start Chrome (Manual)

```
google-chrome --user-data-dir=/data

A Chrome Browser window will appear.
```

 * Install ARC Welder (Manual)

Navigate to :
https://developer.chrome.com/apps/getstarted_arc

Click on "The ARC Welder app"

Select "+ add to chrome"

This will take a few minutes while it downloads the ARC Welder and runtime.

Confirm it is installed : Settings, Extensions.

 * Enable WebGL

Step 1: Type chrome://flags in the address bar

Step 2: Press Ctrl + f and type ” Rendering list “, “Override software rendering list” should come up, Now click on Enable and restart the browser.

Step 3: Close the Chrome window.  

 * Commit these changes to a new image

```
Get the container image id : 

docker ps -a |head -2

Commit these changes to a new image :

docker commit 0f986149884e arc_welder:base
```

 * Almost there.  This is our base image.  You can run this and provide an entrypoint or you can use a Dockerfile. 

Create a Dockerfile with contents : 

```
FROM arc_welder:base

ENTRYPOINT [ "/usr/bin/google-chrome" ]

#This is the app-id of ARC Welder that we installed 
CMD [ "--user-data-dir=/data", "--app-id=emfinbmielocnlhgmfkkmkngdoccbadn" ]

```

Build a new image :

```

docker build -t arc_welder:latest .

```

Start the ARC Welder container :

```
docker run -it \
        --net host \
        --cpuset-cpus 0 \
        --memory 512mb \ # max memory it can use
        -v /tmp/.X11-unix:/tmp/.X11-unix \ # mount the X11 socket
        -e DISPLAY=unix$DISPLAY \
        -v $HOME/Downloads:/root/Downloads \
        --device /dev/snd \ # so we have sound
        --name arcwelder \
        arc_welder:latest

```

Note : If you want to save the state of any apps you run then you will need to add in this line when starting the container :

```
-v $HOME/.config/google-chrome/:/data \ # if you want to save state

```
The ARC Welder app will appear.  

You will be prompted for a .apk file.  In the command above we setup this volume : $HOME/Downloads:/root/Downloads.  On your host you can download a .apk file from http://www.apkmirror.com/ and then select this in the ARC Welder gui.

That's it.  

Tested Angry Birds, Instagram, Twitter, Evernote. 

Tried Facebook, Netflix and AirDroid but hit issues. 

 * What's the point? 

This allows Developers or Testers to start Android apps just by starting a container.  Multiple apps can be run at the same time in complete isolation.  No changes have been made to your host system. 

 * Future work :

Automate the install of ARC Welder 
The end user should be able to pass in the location of a .apk at container runtime and this gets started.
