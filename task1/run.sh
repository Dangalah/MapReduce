#!/usr/bin/env bash

OUT_DIR="top_10"
OUT_DIR1="top_10_2"
NUM_REDUCERS=8

hadoop fs -rm -r -skipTrash ${OUT_DIR}* > /dev/null
hadoop fs -rm -r -skipTrash ${OUT_DIR1}* > /dev/null

yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapred.job.name="top_10_part_1" \
    -D mapreduce.job.reduces=${NUM_REDUCERS} \
    -files mapper.py,reducer.py \
    -mapper mapper.py \
    -reducer reducer.py \
    -input /data/wiki/en_articles_part \
    -output ${OUT_DIR} > /dev/null

yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapred.job.name="top_10_part_2" \
    -D stream.num.map.output.key.fields=2 \
    -D mapreduce.job.reduces=1 \
    -D mapreduce.job.output.key.comparator.class=org.apache.hadoop.mapreduce.lib.partition.KeyFieldBasedComparator \
    -D mapreduce.partition.keycomparator.options='-k2,2nr -k1' \
    -mapper cat \
    -reducer cat \
    -input ${OUT_DIR} \
    -output ${OUT_DIR1} > /dev/null

hdfs dfs -cat ${OUT_DIR1}/part-00000 | head -n 10
