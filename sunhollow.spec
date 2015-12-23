Summary: This is gcc.  Because the versions of gcc that are available to fedora 23 don't work with the versions of ncurses that are available to fedora 23 and this one does.  This is specifically for the purpose of building cloud9.  Do not use it for other purposes.  (It hogs /usr/local/sbin.)
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
BuildRequires: zlib-devel

%description
Back version of gcc because of gcc/ncurses incompatibility.  Use this to build cloud9.  This should only be used in BuildRequires because it selfishly hogs /usr/local/sbin.

%prep
%setup -q
%global debug_package %{nil}

%build
mkdir build &&
echo BUILD &&
ls -lh &&
ls -lh INSTALL &&
cat README &&
cd build &&
../configure --disable-checking --enable-languages=c,c++ \
--enable-multiarch --enable-shared --enable-threads=posix \
--program-suffix=4.8 --with-gmp=/usr/local/lib --with-mpc=/usr/lib \
--with-mpfr=/usr/lib --without-included-gettext --with-system-zlib \
--with-tune=generic \
--prefix=/opt/gcc \
--disable-multilib &&
make -j8 &&
true

%install
rm -rf ${RPM_BUILD_ROOT} &&
mkdir --parents ${RPM_BUILD_ROOT}/opt/gcc &&
cd build &&
make DESTDIR=${RPM_BUILD_ROOT} install &&
export EXE=${RPM_BUILD_ROOT}/opt/gcc/bin/gccVERSION &&
cp ${EXE%.*} ${RPM_BUILD_ROOT}/opt/gcc/bin/gcc &&
true

%clean
rm -rf ${RPM_BUILD_ROOT}

%files
/opt/gcc
