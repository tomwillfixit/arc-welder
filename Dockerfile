
#The base image contains Chrome, ARC Welder app installed and WebGL enabled.  See README.md for more details.

FROM thshaw/arc_welder

MAINTAINER thshaw 

ENTRYPOINT [ "/usr/bin/google-chrome" ]

#This is the app-id of ARC Welder that we installed 
CMD [ "--user-data-dir=/data", "--app-id=emfinbmielocnlhgmfkkmkngdoccbadn" ]

