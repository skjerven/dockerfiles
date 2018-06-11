FROM rocker/tidyverse:latest

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
      tcl8.6-dev \
      tk8.6-dev

RUN Rscript -e 'source("http://bioconductor.org/biocLite.R")' -e 'biocLite("cytofkit")'
