FROM ghcr.io/hiracchi/ubuntu:latest


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
  && \
  apt-get clean && \
  apt-get autoclean && \
  rm -rf /var/lib/apt/lists/* 

# python3-sphinx
# sphinx-intl
# python3-sphinx-celery
# python3-sphinx-autorun
# python3-sphinx-paramlinks
# python3-sphinxcontrib.bibtex
# python3-sphinxcontrib.blockdiag
# python3-sphinxcontrib.nwdiag
# python3-sphinxcontrib.seqdiag
# python3-sphinxcontrib.plantuml
# python3-sphinxcontrib.programoutput
# python3-sphinxcontrib.spelling
# python3-sphinx-bootstrap-theme
# python3-sphinx-rtd-theme


RUN set -x && \
  pip3 install \
  sphinx \
  sphinx-intl \
  sphinx-autobuild \
  sphinx-autorun \
  sphinx-paramlinks \
  sphinx_celery \
  sphinxcontrib-actdiag \
  sphinxcontrib-blockdiag \
  sphinxcontrib-nwdiag \
  sphinxcontrib-seqdiag \
  sphinxcontrib-plantuml \
  sphinxcontrib-programoutput \
  sphinxcontrib-spelling \
  sphinx_rtd_theme \
  sphinx_bootstrap_theme \
  nbsphinx \
  ipykernel \
  jupyterlab \
  numpy \
  scipy \
  simpy \
  pandas \
  matplotlib 

# -----------------------------------------------------------------------------
# entrypoint
# -----------------------------------------------------------------------------
COPY scripts/* /usr/local/bin/
RUN set -x && \
  chmod +x /usr/local/bin/*.sh

WORKDIR "${WORKDIR}"
CMD ["/usr/local/bin/usage.sh"]
