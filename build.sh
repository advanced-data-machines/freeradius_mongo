#!/bin/bash

docker build -t mongo_rlm_build .

CID=$(docker create mongo_rlm_build)
docker cp ${CID}:/usr/lib/rlm_sql_mongo.a lib/
docker cp ${CID}:/usr/lib/rlm_sql_mongo.la lib/
docker cp ${CID}:/usr/lib/rlm_sql_mongo.so lib/

docker rmi ${CID}
echo 
echo "Copy these files to /usr/lib/freeradius directory "
ls -l lib/

echo 
echo "COPY lib/rlm_sql_mongo* /usr/lib/freeradius/"