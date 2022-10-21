Sysbench prepare

docker run \
--network mysql \
--rm=true \
--name=sb-prepare \
severalnines/sysbench \
sysbench \
--db-driver=mysql \
--oltp-table-size=100000 \
--oltp-tables-count=24 \
--threads=1 \
--mysql-host=172.17.0.1 \
--mysql-port=4406 \
--mysql-user=sbtest \
--mysql-password=eiciejei2aichuta7pooLeifi \
/usr/share/sysbench/tests/include/oltp_legacy/parallel_prepare.lua \
run

Run benchmark

docker run \
--network mysql \
--name=sb-run \
severalnines/sysbench \
sysbench \
--db-driver=mysql \
--report-interval=2 \
--mysql-table-engine=innodb \
--oltp-table-size=100000 \
--oltp-tables-count=24 \
--threads=64 \
--time=99999 \
--mysql-host=172.17.0.1 \
--mysql-port=4406 \
--mysql-user=sbtest \
--mysql-password=eiciejei2aichuta7pooLeifi \
/usr/share/sysbench/tests/include/oltp_legacy/oltp.lua \
run