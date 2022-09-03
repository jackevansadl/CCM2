# syntax=docker/dockerfile:experimental

FROM python:3.9-slim-buster

USER root
RUN apt-get update \
    && apt-get -y upgrade \
    && apt install -y python3-dev python3-pip git ssh libopenblas-dev libxc-dev libscalapack-mpi-dev libfftw3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --no-cache-dir notebook jupyterlab jupyterhub gpaw
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}
RUN export PATH=$PATH:/home/${NB_USER}/.local/bin

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
WORKDIR /tmp
RUN gpaw install-data .
