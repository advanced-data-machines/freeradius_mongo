FROM freeradius/freeradius-server:latest


# Enable SQL module and  configure for postgres
COPY ./sql /etc/raddb/mods-enabled/sql
# Define  queries to run for each radius action
COPY ./queries.conf /etc/raddb/mods-config/sql/main/mongo/queries.conf

RUN apt-get update
RUN apt-get install -y libmongoc-1.0-0

COPY lib/rlm_sql_mongo* /usr/lib/freeradius/

#
# Build the image: 
#    docker build -t example .
#
# Run the container: 
#    docker run -it --rm -p 1812:1812/udp -p 1813:1813/udp example -X
#