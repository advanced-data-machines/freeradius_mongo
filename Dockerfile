ARG from=ubuntu:20.04
FROM ${from} as build

ENV DEBIAN_FRONTEND=noninteractive
#
#  Install build tools etc
#
RUN apt-get update
RUN apt-get install -y devscripts equivs git quilt gcc cmake libssl-dev vim

#
#  Create build directory
#
RUN mkdir -p /usr/local/src/repositories
WORKDIR /usr/local/src/repositories

#
#  - Clone Mongo-c-driver from github
#  - make and install per the directions
#  - this will place files needed by radius in directories:
#       /usr/local/include/libbson-1.0/
#       /usr/local/include/libmongoc-1.0/
#   
RUN git clone https://github.com/mongodb/mongo-c-driver.git
WORKDIR /usr/local/src/repositories/mongo-c-driver
RUN mkdir cmake-build
WORKDIR /usr/local/src/repositories/mongo-c-driver/cmake-build
RUN cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF ..
RUN make install


# At this point we now have all the dependancies to build the rlm_sql_mongo
# driver but it is not yet built
# 
#  Shallow clone the FreeRADIUS source
#
WORKDIR /usr/local/src/repositories
ARG source=https://github.com/FreeRADIUS/freeradius-server.git
ARG release=v3.0.x
RUN git clone --depth 1 --single-branch --branch ${release} ${source}
WORKDIR freeradius-server

# 
# The source code file for the driver is located at src/modules/rlm_sql/drivers/rlm_sql_mongo/rlm_sql_mongo.c 
# You can probably build this directly from the file but I found it was just easier to build 
# the entire Freeradius project rather than track down more dependancies
#


#
#  Install build dependencies
#
RUN apt-get install -y libmongoc-1.0-0
RUN git checkout ${release}; \
    if [ -e ./debian/control.in ]; then \
        debian/rules debian/control; \
    fi; \
    echo 'y' | mk-build-deps -irt'apt-get -yV' debian/control

# 
# run ./configure with the arguments to let freeradius know where the dependencies are located
RUN ./configure --prefix=/ --with-mongoc_include_dir=/usr/local/include/libmongoc-1.0/  --with-bson_include_dir=/usr/local/include/libbson-1.0/
RUN make && make install



