---
layout: post
category: tech
tagline: ""
tags : [zookeeper]
comments: true
---
{% include JB/setup %}

## ZooKeeper
### 启动
#### 配置文件
```
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial 
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between 
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just 
# example sakes.
dataDir=/var/applications/zk_test/data1
# the port at which the clients will connect
clientPort=2181
server.1=127.0.0.1:2221:3222
server.2=127.0.0.1:2222:3222
server.3=127.0.0.1:2223:3223
# the maximum number of client connections.
# increase this if you need to handle more clients
#maxClientCnxns=60
#
# Be sure to read the maintenance section of the 
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1

```
#### 启动命令
> bin/zkServer.sh start conf/zoo1.cfg

#### 连接客户端
> bin/zkCli.sh -server 127.0.0.1:2181  
> #如果遇到无法连接，尝试修改iptables  
> -A INPUT -m state --state NEW -m tcp -p tcp --dport 2181 -j ACCEPT  

  
  
### Administration
#### Cross Machine
为了部署一个 能接受 F 台失败机器的集成环境，总共需要总共2*F+1 台机器，所以通常机器数量是 Odd Number

#### Maintainance
##### Ongoing Data Cleanup
- ZooKeeper 不会移除old snapshots 和 log files.  
[PurgeTxnLog](http://zookeeper.apache.org/doc/r3.4.11/api/org/apache/zookeeper/server/PurgeTxnLog.html)实现了基本的 `Retention Policy`  
> java -cp zookeeper.jar:lib/slf4j-api-1.6.1.jar:lib/slf4j-log4j12-1.6.1.jar:lib/log4j-1.2.15.jar:conf org.apache.zookeeper.server.PurgeTxnLog <dataDir> <snapDir> -n <count>

- 3.4.0 后 使用 `autopurge.snapRetainCount` 和 `autopurge.purgeInterval` 参数实现自动清理, [Advance Configuration](http://zookeeper.apache.org/doc/r3.4.11/zookeeperAdmin.html#sc_advancedConfiguration)

##### Monitoring
- 4word Command
```
echo `srst|conf|4word_cmd` |nc localhost 2181  
```
- JMX

#### 避免的坑
- inconsistent lists of servers
- incorrect placement of transaction log
- incorrect Java heap size
  - ZooKeeper jvm设置成 no swap to disk
  - 4G 的内存，不要设置 4G 及以上的 jvm max heap size
- publicly accessible deployment
  - 部署在防火墙内
- 可恢复的重发机制
- tckTime 的设置
  
#### ZooKeeper Waters
`getData()`, `getChildren()`, and `exists()`  

- 一次性的 watchEvent Trigger
> 举例子：/zone1 一次修改后，客户端得到watchEvent Trigger。  
>/zone1 再一次修改后，除非客户端完成read（这会设置一个watcher）
- 客户端看到的信息是order 保证的
- Events
> Created, Deleted, Changed, Child

- Watches 机制保证
  - ZooKeeper Client Lib 保证一切顺序派发
  - node 的 watch event 于真正获取该 node 值之前发生

#### ZooKeeper ACL 控制
- Pluggable ZooKeeper authentication
  - authProvider.1=com.f.MyAuth
```
public interface AuthenticationProvider {
    String getScheme();
    KeeperException.Code handleAuthentication(ServerCnxn cnxn, byte authData[]);
    boolean isValid(String id);
    boolean matches(String id, String aclExpr);
    boolean isAuthenticated();
}
```

### 一致性保证
- Sequential Consistency  
Updates from a client will be applied in the order that they were sent.
- Atomicity  
Updates either succeed or fail -- there are no partial results.
- Single System Image  
A client will see the same view of the service regardless of the server that it connects to.
- Reliability  
1. If a client gets a successful return code, the update will have been applied. On some failures (communication errors, timeouts, etc) the client will not know if the update has applied or not. We take steps to minimize the failures, but the guarantee is only present with successful return codes. (This is called the monotonicity condition in Paxos.)

2. Any updates that are seen by the client, through a read request or successful update, will never be rolled back when recovering from server failures.

- Timeliness  
The clients view of the system is guaranteed to be up-to-date within a certain time bound (on the order of tens of seconds). Either system changes will be seen by a client within this bound, or the client will detect a service outage.