ARG IMAGE
ARG IMAGE_VERSION

FROM ${IMAGE}:${IMAGE_VERSION}

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    gnupg-agent \
    software-properties-common \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    docker-ce docker-ce-cli \
    containerd.io \
    && apt-get purge -y && apt-get autoremove -y && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

ARG ACCOUNT
ARG USERMAIL
ARG USER

RUN mkdir --parents $HOME/.ssh \
    && echo "#eval \"\$(ssh-agent -s)\"" | grep '^#*' >> $HOME/.ssh/config \
    && echo "#ssh-add ~/.ssh/id_rsa_\${ACCOUNT}\n#ssh-add -l\n" | grep '^#*' >> $HOME/.ssh/config \
    && echo "#git clone git@github.com-\${ACCOUNT}:GitHubAccount/Repository.git\nHost github.com-\${ACCOUNT}" | grep '^#*' >> $HOME/.ssh/config \
    && echo "\tHostName github.com\n\tUser git\n\tIdentityFile ~/.ssh/id_rsa_\${ACCOUNT}" | grep '^\t*' >> $HOME/.ssh/config

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    git \
    openssh-client \
    && git config --global user.name ${USER} \
    && git config --global user.email ${USERMAIL} \
    && ssh-keygen -t rsa -b 4096 -N "" -C "${USERMAIL}" -f $HOME/.ssh/id_rsa_${ACCOUNT} \
    && apt-get purge -y && apt-get autoremove -y && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade \
    wheel \
    eggs \
    pip \
    && pip install --upgrade \
    docker \
    jedi \
    rope \
    autopep8 \
    yapf \
    black \
    flake8 \
    ipython \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    emacs-nox \
    && git clone https://github.com/oCh6Z/dot-emacs-python-docker.git $HOME/dot-emacs \
    && ln -s $HOME/dot-emacs/.emacs $HOME/ \
    && ln -s $HOME/dot-emacs/.emacs.d $HOME/

ENTRYPOINT ["/bin/sh", "-c"]

CMD ["bash"]
