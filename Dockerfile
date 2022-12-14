FROM ghcr.io/hiracchi/docker-ubuntu:22.04


ARG WORKDIR="/work"
ENV LC_ALL=C LANG=C DEBIAN_FRONTEND=noninteractive

# setup packages ===============================================================
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
# entrypoint
# -----------------------------------------------------------------------------
COPY scripts/* /usr/local/bin/
RUN set -x && \
  chmod +x /usr/local/bin/*.sh

USER ${USER_NAME}:${GROUP_NAME}
WORKDIR "${WORKDIR}"
EXPOSE 8000
CMD ["/usr/local/bin/usage.sh"]
