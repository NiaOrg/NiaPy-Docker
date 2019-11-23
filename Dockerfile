ARG BASE_CONTAINER=debian:latest
ARG GIT_BRANCH="development"
ARG NB_USER="jovyan"
ARG NB_UID=1000
ARG NB_GROUP="jovyan"
ARG NB_GID=1000
ARG NB_PASSWORD="test1234"
ARG NB_PORT=9999

FROM $BASE_CONTAINER

LABEL tags="python, microframework, nature-inspired-algorithms, swarm-intelligence, optimization-algorithms"
LABEL maintainer="Klemen Berkovic <roxor@gmail.com>"
LABEL github="https://github.com/NiaOrg"
LABEL github-docker="https://github.com/NiaOrg/NiaPy-Docker"
LABEL description="Nature-inspired algorithms are a very popular tool for solving optimization problems. Numerous variants of nature-inspired algorithms have been developed since the beginning of their era. To prove their versatility, those were tested in various domains on various applications, especially when they are hybridized, modified or adapted. However, implementation of nature-inspired algorithms is sometimes a difficult, complex and tedious task. In order to break this wall, NiaPy is intended for simple and quick use, without spending time for implementing algorithms from scratch."

ENV HOME=/home/$NB_USER

USER root
WORKDIR /root

# Update the system
RUN apt update
# Install needed programs
RUN apt install -y git make vim vifm tmux && apt install -y virtualenv && apt install -y pipenv
RUN pip3 install jupyterlab
# Enable prompt color in the skeleton .bashrc before creating the default NB_USER
RUN echo 'export SHELL=/bin/bash' >> /etc/skel/.profile
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc
# Add script
ADD fix-permissions /usr/local/bin/fix-permissions
RUN chmod a+rx /usr/local/bin/fix-permissions
COPY createuser.sh .
RUN chmod a+rx createuser.sh
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    ./createuser.sh $NB_USER $NB_UID $NB_GROUP $NB_GID $HOME && \
    chmod g+w /etc/passwd && \
    fix-permissions $HOME
# Add stings for jupyter
COPY jupyter_notebook_config.py /etc/jupyter/
RUN printf "c.NotebookApp.port = %d\n" $NB_PORT >> /etc/jupyter/jupyter_notebook_config.py
RUN printf "c.NotebookApp.password = u'%s'\n" $(python3 -c "from notebook.auth import passwd; print(passwd('${NB_PASSWORD}'))")  >> /etc/jupyter/jupyter_notebook_config.py
COPY jupyter_server.key /etc/jupyter/
COPY jupyter_cert.pem /etc/jupyter/
RUN fix-permissions /etc/jupyter/

USER $NB_UID
WORKDIR $HOME

# Get and buld NiaPy
RUN git clone https://github.com/kb2623/NiaPy.git -b $GIT_BRANCH
RUN cd NiaPy && make build && cd ..
# Get and buld NiaPy-examples and run jupyter lab
RUN git clone https://github.com/kb2623/NiaPy-examples.git -b $GIT_BRANCH
RUN cd NiaPy-examples && make install

USER $NB_UID
# Set working directory for runing
WORKDIR $HOME/NiaPy-examples
# Open ports
EXPOSE $NB_PORT
# Run the command
CMD make lab
