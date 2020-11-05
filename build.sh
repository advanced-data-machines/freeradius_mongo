#!/bin/bash

docker build -t mongo_rlm_build .

mkdir target/

CID=$(docker create mongo_rlm_build)
docker cp ${CID}:/usr/lib/rlm_sql_mongo.a target/
docker cp ${CID}:/usr/lib/rlm_sql_mongo.la target/
docker cp ${CID}:/usr/lib/rlm_sql_mongo.so target/

docker rmi ${CID}
echo 
echo "Copy these files to /usr/lib/freeradius directory "
ls -l target/

echo 
echo "COPY lib/rlm_sql_mongo* /usr/lib/freeradius/"