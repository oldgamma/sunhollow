#!/bin/bash

VERSION=4.8.2 &&
    RELEASE=0.1.0 &&
    # clean up from the last build
    rm --recursive --force build &&
    # the spec file
    mkdir build &&
    sed -e "s#RELEASE#${RELEASE}#" -e "s#VERSION#${VERSION}#" -e "wbuild/sunhollow-${RELEASE}.spec" sunhollow.spec &&
    # the source file
    wget http://ftp.gnu.org/gnu/gcc/gcc-${VERSION}/gcc-${VERSION}.tar.bz2 &&
    bunzip2  gcc-${VERSION}.tar.bz2 &&
    tar --extract --file gcc-${VERSION}.tar &&
    rm gcc-${VERSION}.tar &&
    mv gcc-${VERSION} build/sunhollow-${VERSION} &&
    tar --create --file build/sunhollow-${VERSION}.tar --directory build sunhollow-${VERSION} &&
    gzip -9 --to-stdout build/sunhollow-${VERSION}.tar > build/sunhollow-${VERSION}.tar.gz &&
    # the source rpm
    mkdir --parents build/init/01 &&
    mock --init --resultdir build/init/01 &&
    mkdir --parents build/buildsrpm/01 &&
    mock --buildsrpm --spec build/sunhollow-${RELEASE}.spec --sources build/sunhollow-${VERSION}.tar.gz --resultdir build/buildsrpm/01 &&
    # the binary rpm
    mkdir --parents build/init/02 &&
    mock --init --resultdir build/init/02 &&
    mkdir --parents build/rebuild/01 &&
    mock --rebuild build/buildsrpm/01/sunhollow-${VERSION}-${RELEASE}.src.rpm --resultdir build/rebuild/01 &&
    # test it
    mkdir --parents build/init/03 &&
    mock --init --resultdir build/init/03 &&
    mkdir --parents build/install/01 &&
    mock --install build/rebuild/01/sunhollow-${VERSION}-${RELEASE}.x86_64.rpm &&
    # these are all the packages I think we need for cloud9
    for PACKAGE in git libxml2-devel libjpeg-devel python gcc-c++ make openssl-devel gcc ruby ruby-devel rubygems tree nodejs npm ncurses ncurses-devel glibc-static
    do
	mkdir --parents build/install/02/${PACKAGE} &&
	    mock --install ${PACKAGE} --resultdir build/install/02/${PACKAGE} &&
	    true
    done &&
    mkdir --parents build/shell/01 &&
    mock --shell "export PATH=/opt/gcc/bin:\${PATH} && git clone git://github.com/c9/core.git c9sdk && cd c9sdk && scripts/install-sdk.sh && true" --resultdir build/shell/01 &&
    # put it in the github repo
    git clone git@github.com:rawflag/dancingleather.git build/dancingleather &&
    cp build/rebuild/01/sunhollow-${VERSION}-${RELEASE}.x86_64.rpm build/dancingleather &&
    cp build/buildsrpm/01/sunhollow-${VERSION}-${RELEASE}.src.rpm build/dancingleather &&
    cd build/dancingleather &&
    git checkout issue-0001-dancingleather &&
    createrepo . &&
    git add sunhollow-${VERSION}-${RELEASE}.x86_64.rpm sunhollow-${VERSION}-${RELEASE}.src.rpm repodata &&
    git commit -am "Adding sunhollow ${VERSION} ${RELEASE}" -S &&
    git push origin issue-0001-dancingleather &&
    true
