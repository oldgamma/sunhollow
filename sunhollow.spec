Summary: This is gcc-4.8.2.  Because the versions of gcc that are available to fedora 23 don't work with the versions of ncurses that are available to fedora 23 and this one does.
Name: sunhollow
Version: 4.8.2
Release: 0.1.0
License: GNU GPL3
Group: Administration
URL: https://gcc.gnu.org/
Source0: %{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildRequires: gmp-devel
BuildRequires: mpfr-devel
BuildRequires: libmpc-devel
BuildRequires: glibc-devel
BuildRequires: flex
BuildRequires: bison
BuildRequires: glibc-static

%description
Back version of gcc because of gcc/ncurses incompatibility.

%prep
%setup -q

%build
mkdir build &&
cd build &&
../configure --disable-checking --enable-languages=c,c++ \
--enable-multiarch --enable-shared --enable-threads=posix \
--program-suffix=4.8 --with-gmp=/usr/local/lib --with-mpc=/usr/lib \
--with-mpfr=/usr/lib --without-included-gettext --with-system-zlib \
--with-tune=generic \
--prefix=${RPM_BUILD_ROOT}/usr/install/gcc-4.8.2 \
--disable-multilib &&
make -j8 &&
true


%install
rm -rf ${RPM_BUILD_ROOT} &&
mkdir --parents ${RPM_BUILD_ROOT}/usr/install/gcc-4.8.2 &&
make install &&
ln --symbolic --force ${RPM_BUILD_ROOT}/usr/install/gcc-4.8.2/bin/gcc4.8 ${RPM_BUILD_ROOT}/usr/bin/gcc &&
true

%clean
rm -rf ${RPM_BUILD_ROOT}


%files
%attr(0555,root,root) /usr/bin/gcc
%attr(0755,root,root) /usr/install

