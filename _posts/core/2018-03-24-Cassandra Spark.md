---
layout: post
category: tech
tagline: ""
tags : [streaming]
comments: true
---
{% include JB/setup %}

#### 整体架构
<pre>
+--------------+--------------+-----------+  
|              |              |           |  
|  Cassandra   |   Spark      |   Result  |  
+--------------+--------------|-----------+  
</pre>

#### Spark Connnector
<http://mvnrepository.com/artifact/com.datastax.spark>
<https://github.com/datastax/spark-cassandra-connector>

##### Driver config
`park-defaults.conf`

>spark.cassandra.connection.host 192.168.6.201
>spark.cassandra.auth.username cassandra
>spark.cassandra.auth.password cassandra
  
##### Dependency
- cassandra-clientutil
- cassandra-driver-core
- cassandra-all

##### System Default Env
`spark-default.env`
```
spark.executor.extraJavaOptions	   -XX:MaxPermSize=896m
spark.executor.memory		   5g
spark.serializer        org.apache.spark.serializer.KryoSerializer
spark.cores.max		32
spark.shuffle.manager	SORT
spark.driver.memory	2g
```

##### System Env
`spark-env.sh`
```
export SPARK_MASTER_IP=127.0.0.1
export SPARK_LOCAL_IP=127.0.0.1
```

#### 启动 spark 集群
##### Master
```
$SPARK_HOME/sbin/start-master.sh
```

##### Worker
```
$SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker spark://master:7077

$SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker spark://master:7077 –webui-port 8083
```
##### Spark Summit
```
$SPARK_HOME/bin/spark-submit –class 应用程序的类名 \
--master spark://master:7077 \
--jars 依赖的库文件 \
spark应用程序的jar包
```

#### 优化配置
`cassandra-env.sh`
```
JVM_OPTS="$JVM_OPTS -XX:+UseParNewGC" 
JVM_OPTS="$JVM_OPTS -XX:+UseConcMarkSweepGC" 
JVM_OPTS="$JVM_OPTS -XX:+CMSParallelRemarkEnabled" 
JVM_OPTS="$JVM_OPTS -XX:SurvivorRatio=8" 
JVM_OPTS="$JVM_OPTS -XX:MaxTenuringThreshold=1"
JVM_OPTS="$JVM_OPTS -XX:CMSInitiatingOccupancyFraction=80"
JVM_OPTS="$JVM_OPTS -XX:+UseCMSInitiatingOccupancyOnly"
JVM_OPTS="$JVM_OPTS -XX:+UseTLAB"
JVM_OPTS="$JVM_OPTS -XX:ParallelCMSThreads=1"
JVM_OPTS="$JVM_OPTS -XX:+CMSIncrementalMode"
JVM_OPTS="$JVM_OPTS -XX:+CMSIncrementalPacing"
JVM_OPTS="$JVM_OPTS -XX:CMSIncrementalDutyCycleMin=0"
JVM_OPTS="$JVM_OPTS -XX:CMSIncrementalDutyCycle=10"
```
如果nodetool无法连接到Cassandra的话，在cassandra-env.sh中添加如下内容
```
JVM_OPTS="$JVM_OPTS -Djava.rmi.server.hostname=ipaddress_of_cassandra"
```