FROM ubuntu:14.04

# Install system packages
RUN apt-get update && apt-get install -y software-properties-common \
build-essential nasm automake wget git bison flex zlib1g-dev
 
# Set environment variables
ENV AIPREFIX=zyx PATH=/zyx/bin:/work/inst/bin:$PATH LD_LIBRARY_PATH=/zyx/lib:/work/inst/lib64:/work/inst/lib:$LD_LIBRARY_PATH   PKG_CONFIG_PATH=/zyx/share/pkgconfig:/zyx/lib/pkgconfig:/work/inst/lib/pkgconfig:/work/inst/share/pkgconfig:$PKG_CONFIG_PATH ACLOCAL_PATH=/zyx/share/aclocal:$ACLOCAL_PATH

# Get auxiliary configuration files and compile base dependencies
ADD build_gcc.sh /work/build_gcc.sh
RUN mkdir -p /work && cd /work && bash build_gcc.sh
RUN rm -rf Python-2.7.13* && wget https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tar.xz && tar xJvf Python-2.7.13.tar.xz && cd Python-2.7.13 && ./configure --prefix=/zyx --enable-shared --enable-unicode=ucs2 && make && make install

RUN cd /work && rm -rf cmake* && wget https://cmake.org/files/v3.8/cmake-3.8.2.tar.gz && tar xzvf cmake-3.8.2.tar.gz && cd cmake-3.8.2 && ./bootstrap --prefix=/work/inst --parallel=2 && make -j 2 && make install
RUN apt-get install -y unzip
RUN cd /work && wget https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip && unzip ninja-linux.zip && cp -a ninja /work/inst/bin

#cleanup
RUN rm -rf /gcc-* && cd /work && rm -rf build gcc-* Python-* cmake* lcms2*
