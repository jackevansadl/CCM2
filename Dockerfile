# syntax=docker/dockerfile:experimental

FROM linuxbrew@sha256:8e005236f950011559384162879aa59b3d91d2a699cc78ae954238b6173b5e24 as base

# USER root
# RUN apt-get update \
#     && apt-get -y upgrade \
#     && apt install -y python3 python3-pip \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

FROM python:3.9-slim-buster AS base2

# RUN python3 -m pip install --upgrade pip

RUN python3 -m pip install --no-cache-dir notebook jupyterlab jupyterhub
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

