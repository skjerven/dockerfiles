FROM centos:7
RUN yum upgrade -y && \
    yum install -y \
        gcc \
        gcc-gfortran \
        libquadmath \
        make \
        python-devel \
        tar \
        wget && \
        mkdir /bench

## install optcray stuff
ADD optcray_galaxy.tar /

RUN echo "/opt/cray/mpt/default/gni/mpich2-gnu/49/lib" >> /etc/ld.so.conf && \
    echo "/opt/cray/pmi/default/lib64" >> /etc/ld.so.conf && \
    echo "/opt/cray/ugni/default/lib64" >> /etc/ld.so.conf && \
    echo "/opt/cray/udreg/default/lib64" >> /etc/ld.so.conf && \
    echo "/opt/cray/xpmem/default/lib64" >> /etc/ld.so.conf && \
    echo "/opt/cray/alps/default/lib64" >> /etc/ld.so.conf && \
    echo "/opt/cray/wlm_detect/default/lib64" >> /etc/ld.so.conf && \
    echo "/bench" >> /etc/ld.so.conf && \
    ldconfig

RUN mkdir -p /bench \
      && wget https://github.com/LLNL/pynamic/archive/1.3.tar.gz \
      && tar -xf 1.3.tar.gz -C /bench \
      && cd /bench/pynamic-1.3/pynamic-pyMPI-2.6a1 \
      && mv * ../..

RUN cd /bench && \
    LDFLAGS="-lpython2.7 -L/opt/cray/mpt/default/gni/mpich2-gnu/49/lib -lmpich_gnu_49" \
    ./config_pynamic.py 495 1850 -e -u 215 1850 -n 100 -c \
        --with-includes="-I/opt/cray/mpt/default/gni/mpich2-gnu/49/include" && \
    chmod -R a+rX /bench && \
    ldconfig
