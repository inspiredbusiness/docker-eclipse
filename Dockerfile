FROM ndeloof/java

# Heavily based on http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/

MAINTAINER Chris White <chris@inspiredbusiness.com.au>

# TODO : variabilize those values
# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer

WORKDIR /home/developer
RUN curl http://eclipse.ialto.com/technology/epp/downloads/release/luna/SR1/eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz | tar -xvz

WORKDIR /home/developer/eclipse
RUN ./eclipse \
	-application org.eclipse.equinox.p2.director \
	-repository http://pydev.org/updates \
	-installIUs org.python.pydev.feature.feature.group \
	-noSplash \
	-clean \
	-purgeHistory

#RUN ./eclipse \
#	-application org.eclipse.equinox.p2.director \
#	-repository http://download.eclipse.org/releases/luna \
#	-installIUs org.eclipse.cdt.sdk.feature.group \
#	-noSplash \
#	-clean \
#	-purgeHistory
	

RUN sudo apt-get update
RUN sudo apt-get install libswt-gtk-3-java -y

RUN sudo apt-get install python-setuptools -y
RUN sudo easy_install pip
RUN sudo pip install docker-py

RUN /bin/bash -c "mkdir -p /home/developer/workspace"
RUN /bin/bash -c "mkdir -p /home/developer/dev/src"

RUN echo "<?xml version='1.0' encoding='UTF-8'?><projectDescription><name>Project</name><comment /><projects /><buildSpec><buildCommand><name>org.python.pydev.PyDevBuilder</name><arguments /></buildCommand></buildSpec><natures><nature>org.python.pydev.pythonNature</nature></natures></projectDescription>" > /home/developer/dev/.project

#RUN /bin/bash -c "mkdir -p /home/developer/workspace/.metadata/.plugins/org.eclipse.core.ui.runtime/.settings/"
#RUN echo "eclipse.preferences.version=1 \nshowIntro=false" > /home/developer/workspace/.metadata/.plugins/org.eclipse.core.ui.runtime/.settings/.org.eclipse.ui.prefs


#RUN sudo apt-get install xvfb -y
#RUN sudo apt-get install xvfb x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic x11-apps -y

#RUN sudo /bin/bash -c "Xvfb :100 -ac&"

#RUN export DISPLAY=:100.0
#RUN sudo xvfb-run -a \
#RUN /home/developer/eclipse/eclipse \
#	-noSplash \
#	-application org.eclipse.cdt.managedbuilder.core.headlessbuild \
#	-data /home/developer/workspace \
#	-import /home/developer/dev 

#RUN ./eclipse -nosplash \
#    -data /home/developer/workspace_name \
#    -application org.eclipse.cdt.managedbuilder.core.headlessbuild \
#    -import /home/developer/dev \
#    -build project \
#    -cleanBuild all

# cat /home/developer/eclipse/configuration/1420277512004.log"

CMD /home/developer/eclipse/eclipse -data /home/developer/workspace -perspective org.python.pydev.ui.PythonPerspective

VOLUME ["/home/developer/workspace","/home/developer/dev/src"]
