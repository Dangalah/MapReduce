#!/usr/bin/env bash

OUT_DIR="out_ml"
OUT_DIR1="out_ml_2"
NUM_REDUCERS=8

hadoop fs -rm -r -skipTrash ${OUT_DIR}* > /dev/null
hadoop fs -rm -r -skipTrash ${OUT_DIR1}* > /dev/null

yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapreduce.job.name="ml" \
    -D mapreduce.job.reducers=${NUM_REDUCERS} \
    -files mapper.py,reducer.py \
    -mapper mapper.py \
    -reducer reducer.py \
    -input /data/minecraft-server-logs \
    -output ${OUT_DIR} > /dev/null

yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapred.job.name="ml_2" \
    -D stream.num.map.output.key.fields=3 \
    -D mapreduce.job.reduces=1 \
    -D mapreduce.job.output.key.comparator.class=org.apache.hadoop.mapreduce.lib.partition.KeyFieldBasedComparator \
    -D mapreduce.partition.keycomparator.options='-k1,1 -k3,3nr' \
    -mapper cat \
    -reducer cat \
    -input ${OUT_DIR} \
    -output ${OUT_DIR1} > /dev/null

hdfs dfs -cat ${OUT_DIR1}/part-00000 | head -n 10
