#!/bin/bash

MASTER_PWD="Hui2oe7thaeshin1oohai5bi9"
SLAVE_PWD="aeveekof1BahDa9eichoo3phe"
CREATE_REPLICATION_USER='CREATE USER "replicator"@"%" IDENTIFIED BY "feipuphePheekahtuDo1Guig6"; GRANT REPLICATION SLAVE ON *.* TO "replicator"@"%"; FLUSH PRIVILEGES;'

docker-compose down -v
rm -rf ./master/data/*
rm -rf ./slave/data/*
docker-compose build
docker-compose up -d

until docker exec master bash -c 'export MYSQL_PWD='"$MASTER_PWD"'; mysql -uroot -h 127.0.0.1 -e ";"'
do
    echo "Waiting for master"
    sleep 5
done
docker exec master sh -c "export MYSQL_PWD=$MASTER_PWD; mysql -u root -e '$CREATE_REPLICATION_USER'"


until docker-compose exec slave sh -c 'export MYSQL_PWD='"$SLAVE_PWD"'; mysql -u root -e ";"'
do
    echo "Waiting for slave database connection..."
    sleep 5
done

MASTER_STATUS=`docker exec master sh -c 'export MYSQL_PWD='"$MASTER_PWD"'; mysql -u root -e "SHOW MASTER STATUS"'`
REPLICATION_LOG=`echo $MASTER_STATUS | awk '{print $6}'`
REPLICATION_POSITION=`echo $MASTER_STATUS | awk '{print $7}'`

SLAVE_CMD='export MYSQL_PWD=aeveekof1BahDa9eichoo3phe; mysql -u root -e "CHANGE MASTER TO MASTER_HOST='\''master'\'',MASTER_USER='\''replicator'\'',MASTER_PASSWORD='\''feipuphePheekahtuDo1Guig6'\'',MASTER_LOG_FILE='\'"$REPLICATION_LOG"\'',MASTER_LOG_POS='"$REPLICATION_POSITION"'; START SLAVE;"'

docker exec slave sh -c "$SLAVE_CMD"

docker exec slave sh -c "export MYSQL_PWD=$SLAVE_PWD; mysql -u root -e 'SHOW SLAVE STATUS \G'"
