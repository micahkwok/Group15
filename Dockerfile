# Docker file for the Chicago Police Department complaint analysis
# Author: Ela Bandari, Elanor Boyle-Stanley, Micah Kwok
# Date: December 10, 2020

FROM rocker/tidyverse

RUN apt-get update

# install R packages
RUN apt-get update -qq && install2.r --error \
    janitor \
    GGally \
    broom \
    docopt \
    lubridate \
    testthat

# install libxt6
RUN apt-get install -y --no-install-recommends libxt6

# install python3 & virtualenv
RUN apt-get install -y \
		python3-pip

# install anaconda & put it in the PATH
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh 
ENV PATH /opt/conda/bin:$PATH

# install docopt for python
RUN conda install docopt -y
    
