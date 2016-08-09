#!/bin/bash

set -e

RELEASE=trusty
KERNEL=wily

if [[ ${RELEASE} == ${KERNEL} ]]; then
  branch=master
  package=linux
  meta_package=linux-meta
  debian_dir=debian.master
else
  branch=lts-backport-${KERNEL}
  package=linux-lts-${KERNEL}
  meta_package=linux-meta-lts-${KERNEL}
  debian_dir=debian.${KERNEL}
fi


# Outputs git logs in the debian changelog format
# $1: revision range
get_changelog() {
  git log --pretty='format:  * %s' "$1" --reverse
}

get_source() {
  git clone git://kernel.ubuntu.com/ubuntu/ubuntu-${RELEASE}.git --branch ${branch}
  pushd ubuntu-${RELEASE}
  latest_tag="$(git describe --abbrev=0 --tags)"
  git checkout "${latest_tag}"
  popd
}

get_meta_source() {
  git clone git://kernel.ubuntu.com/ubuntu/ubuntu-${RELEASE}-meta.git --branch ${branch}
  pushd ubuntu-${RELEASE}-meta
  latest_meta_tag="$(git describe --abbrev=0 --tags)"
  git checkout "${latest_meta_tag}"
  popd
}

apply_patches() {
  pushd ubuntu-${RELEASE}
  git am ../patches/linux/*.patch
  popd
}

apply_meta_patches() {
  pushd ubuntu-${RELEASE}-meta
  git am ../patches/linux-meta/*.patch
  popd
}

update_changelog() {
  pushd ubuntu-${RELEASE}
  local changelog_file=${debian_dir}/changelog
  version=$(dpkg-parsechangelog -l${changelog_file} --show-field Version)
  local changelog="${package} (${version}${VERSION_SUFFIX}) ${RELEASE}; urgency=low

$(get_changelog ${latest_tag}..HEAD)

 -- ${MAINTAINER} <${EMAIL}>  $(date -R)

$(cat ${changelog_file})"
  echo "${changelog}" > ${changelog_file}
  popd
}

update_meta_changelog() {
  pushd ubuntu-${RELEASE}-meta/meta-source
  local changelog_file=debian/changelog
  meta_version=$(dpkg-parsechangelog -l${changelog_file} --show-field Version)
  local changelog="${meta_package} (${meta_version}${VERSION_SUFFIX}) ${RELEASE}; urgency=low

$(get_changelog ${latest_meta_tag}..HEAD)

 -- ${MAINTAINER} <${EMAIL}>  $(date -R)

$(cat ${changelog_file})"
  echo "${changelog}" > ${changelog_file}
  popd
}

build_source_package() {
  pushd "$1"
  fakeroot debian/rules clean
  dpkg-buildpackage -S
  popd
}

upload_to_launchpad() {
  dput "ppa:${PPA}" "$1"
}


get_source
get_meta_source

apply_patches
apply_meta_patches

update_changelog
update_meta_changelog

build_source_package ubuntu-${RELEASE}
build_source_package ubuntu-${RELEASE}-meta/meta-source

upload_to_launchpad "${package}_${version}${VERSION_SUFFIX}_source.changes"
upload_to_launchpad "ubuntu-${RELEASE}-meta/${meta_package}_${meta_version}${VERSION_SUFFIX}_source.changes"
