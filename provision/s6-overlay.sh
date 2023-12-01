#!/bin/bash

set -e

S6_OVERLAY_VERSION="$1"

# Determine which architecture to download s6 for. Die if no match found.
get_arch () {
  ARCH="$(uname -m)"

  case $ARCH in
    "x86_64" )
      echo x86_64
      ;;
    "arm64" | "aarch64" )
      echo aarch64
      ;;
    * )
      >&2 echo Architecture \"$ARCH\" not implemented for s6 provisioning
      exit 1
  esac
}

get_archive_name () {
  S6OL_ARCH="$1"
  S6OL_VERSION="$2"

  if [[ "$S6OL_VERSION" < "3.1.0.0" ]]; then
    echo "s6-overlay-${S6OL_ARCH}-${S6OL_VERSION}.tar.xz"
  else
    echo "s6-overlay-${S6OL_ARCH}.tar.xz"
  fi
}

download_and_expand_archive () {
  S6OL_ARCH="$1"
  S6OL_VERSION="$2"

  TARBALL=$(get_archive_name "${S6OL_ARCH}" "${S6OL_VERSION}")

  S6OL_DOWNLOAD_PATH="https://github.com/just-containers/s6-overlay/releases/download/v${S6OL_VERSION}"

  # We're using parens with `cd` and `curl` to temporarily do work in a different directory using a subshell.
  # This allows us to use `curl` to download to a different directory than the current one. Thurl.

  (cd /tmp && curl -LO "${S6OL_DOWNLOAD_PATH}/${TARBALL}")
  tar -C / -Jxpf /tmp/$TARBALL
}

download_and_expand_archive "$(get_arch)" "${S6_OVERLAY_VERSION}"
download_and_expand_archive "noarch" "${S6_OVERLAY_VERSION}"

rm -rf /tmp/*
