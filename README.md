# freeradius_mongo

This is a simple project that demonstrates how to build the **rlm_sql_mongo** drivers required in order to allow FreeRadius to work with the Mongo NoSQL Datastore.

## tl;dr
Run the bash script ./build.sh (requires docker) and copy the files output to the target/ directory to the /usr/lib/freeradius directory of you freeradius server or docker container.

## Abstract
v3.0.x of Radius states explicitly that the mongo driver is "experimental", however, the opportunity to greatly simplify our backend datastore was compelling enough to explore this option.

Unfortunately, there is very little documentation available as to how to get this module to work.   Using the supported docker image [freeradius/freeradius-server:latest](https://hub.docker.com/r/freeradius/freeradius-server) simply enabling this inside **mods-enable/sql** produces the following error:

> Could not link driver rlm_sql_mongo: /usr/lib/freeradius/rlm_sql_mongo.so:  cannot open shared object file: No such file or directory Make sure it (and all its dependent libraries!) are in the search path of your system's ld /etc/freeradius/3.0/mods-enabled/sql[27]: Instantiation failed for module "sql"

See github [issues](https://github.com/FreeRADIUS/freeradius-server/issues?q=mongo)

## Mongo Support
The Dockerfile included in this project outlines the steps we used to build the **rlm_sql_mongo.so** drivers required by FreeRadius v3.0.x in order enable this module.

1. Run ./build.sh
2. Output from the above script will be placed in the directory **target/**
3. Copy output files from above to /usr/lib/freeradius (see [example](../example/Dockerfile))


## Conclusion
This allowed us to continue testing FreeRadius with MongoDB.  If anyone has an easier way to do this I'd very much appreciate hearing from you.  
