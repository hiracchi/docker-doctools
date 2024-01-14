FROM ubuntu:22.04

ARG GROUP_NAME=docker
ARG USER_NAME=docker
ARG USER_ID=1000
ARG GROUP_ID=1000
ENV GROUP_NAME=${GROUP_NAME}
ENV USER_NAME=${USER_NAME}

ARG WORKDIR="/work"


# -----------------------------------------------------------------------------
# base settings
# -----------------------------------------------------------------------------
# switch apt repository
ARG APT_SERVER="archive.ubuntu.com"
# ARG APT_SERVER="jp.archive.ubuntu.com"
# ARG APT_SERVER="ftp.riken.jp/Linux"
# ARG APT_SERVER="ftp.jaist.ac.jp/pub/Linux/"

ENV TZ="Asia/Tokyo"
ENV LC_ALL=C.UTF-8 LANG=C.UTF-8 DEBIAN_FRONTEND=noninteractive

RUN set -x && \
  sed -i -e "s|archive.ubuntu.com|${APT_SERVER}|g" /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  apt-utils sudo wget curl ca-certificates gnupg locales tzdata bash \
  && \
  apt-get update && \
  apt-get upgrade -y && \
  echo "dash dash/sh boolean false" | debconf-set-selections && \
  dpkg-reconfigure dash && \
  locale-gen en_US.UTF-8 && \
  locale-gen ja_JP.UTF-8 && \
  update-locale LANG=ja_JP.UTF-8 && \
  echo "${TZ}" > /etc/timezone && \
  mv /etc/localtime /etc/localtime.orig && \
  ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*


# -----------------------------------------------------------------------------
# setup packages 
# -----------------------------------------------------------------------------
USER root
RUN set -x && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  make \
  python3 \
  python3-pip \
  pandoc \
  texlive-full \
  texlive-science \
  texlive-lang-japanese \
  texlive-lang-cjk \
  texlive-luatex \
  texlive-fonts-recommended \
  texlive-fonts-extra \
  xdvik-ja \
  gv \
  evince \
  dvipng \
  gv nkf gnuplot tgif gimp inkscape mimetex latexdiff latexmk \
  libjs-mathjax \
  fonts-mathjax fonts-mathjax-extras \
  \
  python3-sphinx \
  sphinx-intl \
  python3-sphinx-celery \
  python3-sphinx-autobuild \
  python3-sphinx-autorun \
  python3-sphinx-paramlinks \
  python3-sphinxcontrib.actdiag \
  python3-sphinxcontrib.bibtex \
  python3-sphinxcontrib.blockdiag \
  python3-sphinxcontrib.nwdiag \
  python3-sphinxcontrib.seqdiag \
  python3-sphinxcontrib.plantuml \
  python3-sphinxcontrib.programoutput \
  python3-sphinxcontrib.spelling \
  python3-sphinx-bootstrap-theme \
  python3-sphinx-rtd-theme \
  python3-notebook \
  python3-nbsphinx \
  python3-ipywidgets \
  python3-widgetsnbextension \
  python3-ipykernel \
  python3-msgpack \
  python3-yaml \
  python3-h5py \
  python3-tqdm \
  python3-xlrd \
  python3-xlwt \
  python3-numpy \
  python3-scipy \
  python3-sympy \
  python3-pandas \
  python3-matplotlib \
  python3-sklearn-lib \
  python3-requests \
  python3-bs4 \
  cython3 \
  && \
  apt-get clean && \
  apt-get autoclean && \
  rm -rf /var/lib/apt/lists/* 


# -----------------------------------------------------------------------------
# fixuid
# -----------------------------------------------------------------------------
RUN set -x && \
  groupadd --gid ${GROUP_ID} ${GROUP_NAME} && \
  useradd --uid ${USER_ID} -g ${GROUP_NAME} -G sudo,root \
  --home-dir /home/${USER_NAME} --create-home \
  --shell /usr/bin/bash ${USER_NAME} && \
  echo "${USER_NAME}:${USER_NAME}" | chpasswd && \
  echo "%${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${USER_NAME} && \
  chmod 0400 /etc/sudoers.d/${USER_NAME}


RUN set -x && \
  curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.5.1/fixuid-0.5.1-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
  chown root:root /usr/local/bin/fixuid && \
  chmod 4755 /usr/local/bin/fixuid && \
  mkdir -p /etc/fixuid && \
  printf "user: ${USER_NAME}\ngroup: ${GROUP_NAME}\n" > /etc/fixuid/config.yml


# -----------------------------------------------------------------------------
# entrypoint
# -----------------------------------------------------------------------------
COPY scripts/* /usr/local/bin/
RUN set -x && \
  chmod +x /usr/local/bin/*.sh

USER ${USER_NAME}:${GROUP_NAME}
WORKDIR "${WORKDIR}"
EXPOSE 8000
CMD ["/usr/local/bin/usage.sh"]

