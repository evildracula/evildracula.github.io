---
layout: post
category: tech
tagline: ""
tags : [stream]
comments: true
---
{% include JB/setup %}
### Hadoop 配置
hadoop配置主要涉及hdfs-site.xml，core-site.xml，mapred-site.xml，yarn-site.xml四个文件。以下详细介绍每个文件的配置。  

#### core-site.xml
```
<configuration>  
<property>  
      <name>fs.defaultFS</name>  
      <value>hdfs://cluster1</value>  
      <description>HDFS namenode的逻辑名称，也就是namenode HA,此值要对应hdfs-site.xml里的dfs.nameservices</description>  
</property>  
<property>  
    <name>hadoop.tmp.dir</name>  
    <value>/home/hadoop/bigdata/tmp</value>  
    <description>hdfs中namenode和datanode的数据默认放置路径，也可以在hdfs-site.xml中分别指定</description>  
</property>  
<property>  
        <name>ha.zookeeper.quorum</name>  
        <value>m7-psdc-kvm01:2181,m7-psdc-kvm02:2181,m7-psdc-kvm03:2181</value>  
        <description>zookeeper集群的地址和端口，zookeeper集群的节点数必须为奇数</description>  
</property>  
</configuration>  
```

#### hdfs-site.xml的配置（重点配置）
```
<configuration>  
    <property>  
        <name>dfs.name.dir</name>  
        <value>/home/hadoop/bigdata/nn</value>  
        <description>namenode的数据放置目录</description>  
    </property>  
    <property>  
        <name>dfs.data.dir</name>  
        <value>/home/hadoop/bigdata/dn</value>  
        <description>datanode的数据放置目录</description>  
    </property>  
    <property>  
        <name>dfs.replication</name>  
        <value>2</value>  
        <description>数据块的备份数，默认是3</description>  
    </property>  
    <property>  
        <name>dfs.nameservices</name>  
        <value>cluster1</value>  
        <description>HDFS namenode的逻辑名称，也就是namenode HA</description>  
    </property>  
    <property>  
        <name>dfs.ha.namenodes.cluster1</name>  
        <value>ns1,ns2</value>  
        <description>nameservices对应的namenode逻辑名</description>  
    </property>  
    <property>  
        <name>dfs.namenode.rpc-address.cluster1.ns1</name>  
        <value>m7-psdc-kvm01:8020</value>  
        <description>指定namenode(ns1)的rpc地址和端口</description>  
    </property>  
    <property>  
        <name>dfs.namenode.http-address.cluster1.ns1</name>  
        <value>m7-psdc-kvm01:50070</value>  
        <description>指定namenode(ns1)的web地址和端口</description>  
    </property>  
    <property>  
        <name>dfs.namenode.rpc-address.cluster1.ns2</name>  
        <value>m7-psdc-kvm02:9000</value>  
        <description>指定namenode(ns2)的rpc地址和端口</description>  
    </property>  
    <property>  
        <name>dfs.namenode.http-address.cluster1.ns2</name>  
        <value>m7-psdc-kvm02:50070</value>  
        <description>指定namenode(ns2)的web地址和端口</description>  
    </property>  
    <property>  
        <name>dfs.namenode.shared.edits.dir</name>  
        <value>qjournal://m7-psdc-kvm01:8485;m7-psdc-kvm02:8485;m7-psdc-kvm03:8485;m7-psdc-kvm04:8485/cluster1 </value>  
        <description>这是NameNode读写JNs组的uri，active NN 将 edit log 写入这些JournalNode，而 standby NameNode 读取这些 edit log，并作用在内存中的目录树中</description>  
    </property>  
    <property>  
        <name>dfs.journalnode.edits.dir</name>  
        <value>/home/hadoop/bigdata/journal</value>  
        <description>journalNode 所在节点上的一个目录，用于存放 editlog 和其他状态信息。</description>  
    </property>  
    <property>  
           <name>dfs.ha.automatic-failover.enabled</name>  
           <value>true</value>  
           <description>启动自动failover。自动failover依赖于zookeeper集群和ZKFailoverController（ZKFC），后者是一个zookeeper客户端，用来监控NN的状态信息。每个运行NN的节点必须要运行一个zkfc</description>  
    </property>  
    <property>  
        <name>dfs.client.failover.proxy.provider.cluster1</name>  
        <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>  
        <description>配置HDFS客户端连接到Active NameNode的一个java类</description>  
    </property>  
    <property>  
        <name>dfs.ha.fencing.methods</name>  
        <value>sshfence</value>  
        <description>解决HA集群脑裂问题（即出现两个 master 同时对外提供服务，导致系统处于不一致状态）。在 HDFS HA中，JournalNode 只允许一个 NameNode 写数据，不会出现两个 active NameNode 的问题,但是，当主备切换时，之前的 active NameNode 可能仍在处理客户端的 RPC 请求，为此，需要增加隔离机制（fencing）将之前的 active NameNode 杀死。常用的fence方法是sshfence，要指定ssh通讯使用的密钥dfs.ha.fencing.ssh.private-key-files和连接超时时间</description>  
    </property>  
    <property>  
        <name>dfs.ha.fencing.ssh.private-key-files</name>  
        <value>/home/hadoop/.ssh/id_rsa</value>  
        <description>ssh通讯使用的密钥</description>  
    </property>  
    <property>  
        <name>dfs.ha.fencing.ssh.connect-timeout</name>  
        <value>30000</value>  
        <description>连接超时时间</description>  
    </property>  
</configuration>  
```
#### mapred-site.xml的配置
```
<configuration>  
<property>  
        <name>mapreduce.framework.name</name>  
        <value>yarn</value>  
        <description>指定运行mapreduce的环境是yarn，与hadoop1截然不同的地方</description>  
</property>  
<property>  
        <name>mapreduce.jobhistory.address</name>  
        <value>m7-psdc-kvm01:10020</value>  
         <description>MR JobHistory Server管理的日志的存放位置</description>  
</property>  
<property>  
        <name>mapreduce.jobhistory.webapp.address</name>  
        <value>m7-psdc-kvm01:19888</value>  
        <description>查看历史服务器已经运行完的Mapreduce作业记录的web地址，需要启动该服务才行</description>  
</property>  
<property>  
   <name>mapreduce.jobhistory.done-dir</name>  
   <value>/home/hadoop/bigdata/done</value>  
   <description>MR JobHistory Server管理的日志的存放位置,默认:/mr-history/done</description>  
</property>  
<property>  
   <name>mapreduce.jobhistory.intermediate-done-dir</name>  
   <value>hdfs://mycluster-pha/mapred/tmp</value>  
   <description>MapReduce作业产生的日志存放位置，默认值:/mr-history/tmp</description>  
</property>  
</configuration>  
```
#### yarn-site.xml 
```
<configuration>  
  
  
<!-- Site specific YARN configuration properties -->  
    <property>  
                <name>yarn.resourcemanager.ha.enabled</name>  
                <value>true</value>  
        </property>  
    <property>  
                <name>yarn.resourcemanager.cluster-id</name>  
                <value>yarn-cluster1</value>  
        </property>  
<!-- 指定RM的名字 -->  
        <property>  
                <name>yarn.resourcemanager.ha.rm-ids</name>  
                <value>rm1,rm2</value>  
        </property>  
<!-- 分别指定RM的地址 -->  
        <property>  
                <name>yarn.resourcemanager.hostname.rm1</name>  
                <value>m7-psdc-kvm03</value>  
        </property>  
        <property>  
                <name>yarn.resourcemanager.hostname.rm2</name>  
                <value>m7-psdc-kvm02</value>  
        </property>  
    <property>  
                <name>yarn.resourcemanager.recovery.enabled</name>  
                <value>true</value>  
        </property>  
  
  
        <property>  
                <name>yarn.resourcemanager.store.class</name>  
                <value>org.apache.hadoop.yarn.server.resourcemanager.recovery.ZKRMStateStore</value>  
        </property>  
        <!-- 指定zk集群地址 -->  
        <property>  
                <name>yarn.resourcemanager.zk-address</name>  
                <value>m7-psdc-kvm01:2181,m7-psdc-kvm02:2181,m7-psdc-kvm03:2181</value>  
        </property>  
    <property>  
        <name>yarn.resourcemanager.ha.automatic-failover.embedded</name>  
        <value>true</value>  
    </property>  
    <property>  
        <name>yarn.resourcemanager.admin.address.rm1</name>  
        <value>m7-psdc-kvm03:8033</value>  
    </property>  
    <property>  
        <name>yarn.resourcemanager.admin.address.rm2</name>  
        <value>m7-psdc-kvm02:8033</value>  
    </property>  
  
  
    <property>  
        <name>yarn.resourcemanager.address.rm1</name>  
        <value>m7-psdc-kvm03:8032</value>  
    </property>  
    <property>  
        <name>yarn.resourcemanager.address.rm2</name>  
        <value>m7-psdc-kvm02:8032</value>  
    </property>  
  
  
    <property>  
        <name>yarn.resourcemanager.resource-tracker.address.rm1</name>  
        <value>m7-psdc-kvm03:8031</value>  
    </property>  
    <property>  
        <name>yarn.resourcemanager.resource-tracker.address.rm2</name>  
        <value>m7-psdc-kvm02:8031</value>  
    </property>  
  
  
    <property>  
        <name>yarn.resourcemanager.webapp.address.rm1</name>  
        <value>m7-psdc-kvm03:8088</value>  
    </property>  
    <property>  
        <name>yarn.resourcemanager.webapp.address.rm2</name>  
        <value>m7-psdc-kvm02:8088</value>  
    </property>  
  
  
    <property>  
        <name>yarn.resourcemanager.scheduler.address.rm1</name>  
        <value>m7-psdc-kvm03:8030</value>  
    </property>  
    <property>  
        <name>yarn.resourcemanager.scheduler.address.rm2</name>  
        <value>m7-psdc-kvm02:8030</value>  
    </property>  
  
  
       <property>  
        <name>yarn.nodemanager.aux-services</name>  
        <value>mapreduce_shuffle</value>  
        <description>默认</description>  
       </property>  
  
  
    <property>  
        <name>yarn.nodemanager.pmem-check-enabled</name>  
        <value>false</value>  
    </property>  
    <property>  
        <name>yarn.log-aggregation-enable</name>  
        <value>true</value>  
    </property>  
<!--  
    <property>  
        <name>yarn.resourcemanager.ha.id</name>  
        <value>rm1</value>  
    </property>  
-->  
    <property>  
        <name>yarn.nodemanager.delete.debug-delay-sec</name>  
        <value>86400</value>  
    </property>  
  
  
       <property>  
        <name>yarn.nodemanager.auxservices.mapreduce.shuffle.class</name>  
        <value>org.apache.hadoop.mapred.ShuffleHandler</value>  
       </property>  
       <property>  
        <name>yarn.nodemanager.resource.memory-mb</name>  
        <value>102400</value>  
     </property>  
    <property>  
        <name>yarn.nodemanager.resource.cpu-vcores</name>  
        <value>20</value>  
    </property>  
    <property>  
        <name>yarn.scheduler.maximum-allocation-mb</name>  
        <value>102400</value>  
    </property>  
</configuration>
```

### ZooKeeper 配置
> Hadoop 正常配置  

### Hadoop 集群启动

#### 第一次配置启动
- 在三个节点上启动Journalnode deamons，然后jps，出现JournalNode进程。  
```
sbin/./hadoop-daemon.sh start journalnode
jps
JournalNode
```

- 格式化master上的namenode（任意一个），然后启动该节点的namenode。
```
bin/hdfs namenode -format
sbin/hadoop-daemon.sh start namenode
```
- 在另一个namenode节点slave1上同步master上的元数据信息
```
bin/hdfs namenode -bootstrapStandby
```
- 停止hdfs上的所有服务
```
sbin/stop-dfs.sh
```
- 初始化zkfc
```
bin/hdfs zkfc -formatZK
```
- 启动hdfs
```
sbin/start-dfs.sh
```
- 启动yarn
```
sbin/start-yarn.sh
```

#### 非第一次配置启动
- 直接启动hdfs和yarn即可，namenode、datanode、journalnode、DFSZKFailoverController都会自动启动。
```
sbin/start-dfs.sh
```
- 启动yarn
```
sbin/start-yarn.sh
```