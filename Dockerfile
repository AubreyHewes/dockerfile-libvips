FROM debian:buster-slim

MAINTAINER Marc Bachmann <marc.brookman@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

ENV LIBVIPS_VERSION 8.10.1

RUN apt-get update -yq

RUN \
  # Install dependencies
  apt-get install -yq \
    automake \
    build-essential \
    curl \
    imagemagick \
    gobject-introspection \
    gtk-doc-tools \
    libglib2.0-dev \
    libjpeg-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libheif-dev \
    libtiff5-dev \
    libgif-dev \
    libexif-dev \
    libxml2-dev \
    libpoppler-glib-dev \
    swig \
    libmagickwand-dev \
    libpango1.0-dev \
    libmatio-dev \
    libopenslide-dev \
    libcfitsio-dev \
    libgsf-1-dev \
    fftw3-dev \
    liborc-0.4-dev \
    librsvg2-dev

# Build libvips
RUN cd /tmp && \
  curl -LsO https://github.com/libvips/libvips/releases/download/v$LIBVIPS_VERSION/vips-$LIBVIPS_VERSION.tar.gz && \
  tar zvxf vips-$LIBVIPS_VERSION.tar.gz && \
  cd /tmp/vips-$LIBVIPS_VERSION && \
  ./configure --enable-debug=no --without-python $1 && \
  make && \
  make install && \
  ldconfig

# Clean up
RUN apt-get remove -y curl automake build-essential && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
