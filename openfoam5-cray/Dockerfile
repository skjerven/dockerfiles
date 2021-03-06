FROM ubuntu:17.04

# Set up development environment
RUN apt-get --yes --force-yes update \
      && apt-get install -y -qq \
      apt-transport-https \
      bash-builtins \
      bash-completion \
      binutils-dev \
      bison \
      build-essential \
      cmake \
      emacs \
      flex \
      g++ \
      gcc \
      gfortran \
      libboost-all-dev \
      libopenblas-dev \
      libreadline-dev \
      make \
      nano \
      python \
      python-dev \
      software-properties-common \
      vim \
      wget \
      zlib1g-dev \
      && apt-get clean all

# Build MPICH
RUN mkdir /build
RUN cd /build \
      && wget http://www.mpich.org/static/downloads/3.2/mpich-3.2.tar.gz \
      && tar xvzf mpich-3.2.tar.gz \
      && cd /build/mpich-3.2 \
      && ./configure --prefix=/usr \
      && make -j4 \
      && make install \
      && make clean \
      && rm /build/mpich-3.2.tar.gz

# Download OpenFOAM sources
RUN mkdir -p /opt/openfoam
RUN cd /opt/openfoam \
      && wget https://github.com/OpenFOAM/OpenFOAM-5.x/archive/version-5.0.tar.gz -O OpenFOAM-5.x-version-5.0.tar.gz \
      && tar xzvf OpenFOAM-5.x-version-5.0.tar.gz \
      && rm OpenFOAM-5.x-version-5.0.tar.gz \
      && mv OpenFOAM-5.x-version-5.0 OpenFOAM-5.0

RUN cd /opt/openfoam \
      && wget https://github.com/OpenFOAM/ThirdParty-5.x/archive/version-5.0.tar.gz -O ThirdParty-5.x-version-5.0.tar.gz \
      && tar xzvf ThirdParty-5.x-version-5.0.tar.gz \
      && rm ThirdParty-5.x-version-5.0.tar.gz \
      && mv ThirdParty-5.x-version-5.0 ThirdParty-5.0

# Edit config files
RUN cd /opt/openfoam/OpenFOAM-5.0/etc \
      && sed -i 's/export FOAM_INST_DIR=$(/# export FOAM_INST_DIR=$(/g' bashrc \
      && sed -i 's/export FOAM_INST_DIR=$HOME/# export FOAM_INST_DIR=$HOME/g' bashrc \
      && sed -i 's/# export FOAM_INST_DIR=\/opt\/$WM_PROJECT/export FOAM_INST_DIR=\/opt\/openfoam/g' bashrc \
      && sed -i 's/export WM_MPLIB=SYSTEMOPENMPI/export WM_MPLIB=SYSTEMMPI/g' bashrc \
      && cd /opt/openfoam/OpenFOAM-5.0/wmake/rules/linux64Gcc \
      && sed -i 's/gcc/mpicc/g' c \
      && sed -i 's/g++/mpicxx/g' c++

# Compile
# NOTE: We change shell here to ensure the correct OpenFOAM environment is set
SHELL ["/bin/bash", "-c"]
ENV MPI_ROOT=/usr
ENV MPI_ARCH_FLAGS="-DMPICH_SKIP_MPICXX"
ENV MPI_ARCH_INC="-I$MPI_ROOT/include"
ENV MPI_ARCH_LIBS="-L$MPI_ROOT/lib -lmpi"
ENV WM_NCOMPPROCS=8
RUN cd /opt/openfoam \
      && source OpenFOAM-5.0/etc/bashrc \
      && cd /opt/openfoam/ThirdParty-5.0 \
      && ./Allwmake \
      && cd /opt/openfoam/OpenFOAM-5.0 \
      && ./Allwmake

# Setup OpenFOAM bashrc to be sourced at image startup
#RUN echo "source /opt/openfoam/openfoam-5.0/etc/bashrc" >> /root/.bashrc

COPY ./openfoam_env.sh /opt/openfoam
ENTRYPOINT ["/opt/openfoam/openfoam_env.sh"]
