#!/bin/bash

RELEASE=0.1.0 &&
    rm --recursive --force sunhollow-*.spec gcc-4.8.2* build &&
    sed -e "s#RELEASE#${RELEASE}#" -e "wsunhollow-${RELEASE}.spec" sunhollow.spec &&
    wget http://ftp.gnu.org/gnu/gcc/gcc-4.8.2/gcc-4.8.2.tar.bz2 &&
    bunzip2  gcc-4.8.2.tar.bz2 &&
    gzip gcc-4.8.2.tar &&
    mkdir --parents build/init/01 &&
    mock --init --resultdir build/init/01 &&
    mkdir --parents build/buildsrpm/01 &&
    mock --buildsrpm --spec sunhollow-${RELEASE}.spec --sources gcc-4.8.2.tar.gz --resultdir build/buildsrpm/01 &&
    true
