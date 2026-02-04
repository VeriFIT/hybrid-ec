#FROM docker.io/conda/miniconda3
FROM ubuntu:20.04
WORKDIR /

RUN apt-get update                                                                                                      && \
    DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata                                                 && \
    apt-get install -y vim tmux time wget less curl build-essential gcc make emacs rlwrap htop bc locales locales-all

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV LANGUAGE C.UTF-8


RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh      && \
    bash ./Miniconda3-latest-Linux-x86_64.sh -b                                  

ENV PATH="$PATH:/root/miniconda3/bin"

RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main                  && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r                     && \
    conda create -y -n clingo-lpx -c potassco/label/dev-20 -c conda-forge clingo-lpx                    && \
    conda create -y -n clingcon -c potassco/label/dev -c conda-forge clingcon                           && \
    conda init                                                                                          && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["sleep", "infinity"]