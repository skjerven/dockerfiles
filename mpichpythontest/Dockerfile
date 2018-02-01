FROM ubuntu:latest

RUN apt-get update \
      && apt-get install -y autoconf automake gcc g++ make gfortran wget python python-dev \
      && apt-get clean all

### Build MPICH ###

ARG MPICH_VERSION="3.2"
ARG MPICH_CONFIGURE_OPTIONS="--disable-fortran"
ARG MPICH_MAKE_OPTIONS="-j4"

RUN mkdir /tmp/mpich-build
WORKDIR /tmp/mpich-build

RUN wget http://www.mpich.org/static/downloads/3.2/mpich-3.2.tar.gz \
  && tar xvzf mpich-3.2.tar.gz \
  && cd mpich-${MPICH_VERSION}  \
  && ./configure ${MPICH_CONFIGURE_OPTIONS} \
  && make ${MPICH_MAKE_OPTIONS} \
  && make install \
  && rm -rf /tmp/mpich-build

# Test MPICH
RUN mkdir /tmp/mpich-test
WORKDIR /tmp/mpich-test
COPY mpich-test .
RUN sh test.sh
RUN rm -rf /tmp/mpich-test

### Build MPI4PY ###

ARG MPI4PY_VERSION="3.0.0"

RUN mkdir /tmp/mpi4py-build
WORKDIR /tmp/mpi4py-build

RUN wget https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.0.0.tar.gz \
      && tar xzvf mpi4py-${MPI4PY_VERSION}.tar.gz \
      && cd mpi4py-${MPI4PY_VERSION} \
      && python setup.py build \
      && python setup.py install \
      && rm -rf /tmp/mpich-build

### Build OSU Benchmarks ###

ARG OSU_BENCH_VERSION=5.4
ARG OSU_BENCH_CONFIGURE_OPTIONS="--prefix=/opt/osu CC=mpicc CXX=mpicxx"
ARG OSU_BENCH_MAKE_OPTIONS="-j4"

RUN mkdir -p /tmp/osu-benchmark-build
WORKDIR /tmp/osu-benchmark-build

RUN wget http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-${OSU_BENCH_VERSION}.tar.gz \
      && tar xzvf osu-micro-benchmarks-${OSU_BENCH_VERSION}.tar.gz \
      && cd osu-micro-benchmarks-${OSU_BENCH_VERSION} \
      && ./configure ${OSU_BENCH_CONFIGURE_OPTIONS} \
      && make ${OSU_BENCH_MAKE_OPTIONS} \
      && make install \
      && rm -rf /tmp/osu-benchmark-build

# Test benchmark
RUN cd /opt/osu/libexec/osu-micro-benchmarks/mpi/one-sided \
      && mpiexec --version \
      && mpirun -n 2 ./osu_get_latency

# Add Cray libraries"
RUN printf "/opt/cray/pe/mpt/7.7.0/gni/mpich-gnu-abi/5.1/lib\n" >> /etc/ld.so.conf \
    && printf "/opt/cray/pmi/default/lib64\n/opt/cray/ugni/default/lib64\n" >> /etc/ld.so.conf \
    && printf "/opt/cray/udreg/default/lib64\n/opt/cray/xpmem/default/lib64\n" >> /etc/ld.so.conf \
    && printf "/opt/cray/alps/default/lib64\n/opt/cray/wlm_detect/default/lib64\n" >> /etc/ld.so.conf \
    && ldconfig

CMD ["/bin/bash"]
