---
layout: post
category: tech
tagline: ""
tags : [devops]
comments: true
---
{% include JB/setup %}

### keytool
- 生成key
```
keytool -genkeypair -alias avro -keyalg RSA -keystore mykeystore/keystore.jks -dname "CN=localhost, OU=localhost,O=localhost, L=SH, ST=SH, C=CN" -keypass changeit -storepass changeit
```

- 查阅
```
keytool -list -v -alias avro -keystore mykeystore/keystore.jks -storepass changeit
```

- 导出
```
keytool -export -alias avro -keystore mykeystore/keystore.jks -rfc -file mykeystore/mycert.cer
```

- 生成 truststore
```
keytool -import -alias avro -file mykeystore/mycert.cer  -keystore truststore.jks
```


### Avro Source Agent
#### Command
sudo bin/flume-ng agent -n agent -c conf -f conf/avro-src.conf -Dflume.root.logger=INFO,console
#### Config
```
agent.sources = src-avro
agent.channels = memoryChannel
agent.sinks = loggerSink
# For each one of the sources, the type is defined
agent.sources.src-avro.type =avro
# The channel can be defined as follows.
agent.sources.src-avro.channels = memoryChannel
agent.sources.src-avro.bind=127.0.0.1
agent.sources.src-avro.port=1000
agent.sources.src-avro.ssl=true
agent.sources.src-avro.keystore=/home/yuanhui0628/temp/mykeystore/keystore.jks
agent.sources.src-avro.keystore-password=changeit
agent.sources.src-avro.keystore-type=JKS
# Each sink's type must be defined
agent.sinks.loggerSink.type = logger
#Specify the channel the sink should use
agent.sinks.loggerSink.channel = memoryChannel
# Each channel's type is defined.
agent.channels.memoryChannel.type = memory
# Other config values specific to each type of channel(sink or source)
# can be defined as well
# In this case, it specifies the capacity of the memory channel
agent.channels.memoryChannel.capacity = 100 

```

### Avro Sink Agent
#### Command
bin/flume-ng agent -n agent -c conf -f conf/avro-agent.conf -Dflume.root.logger=INFO,console

#### Config
```
agent.sources = netSrc
agent.channels = memoryChannel
agent.sinks = avro-sink
# For each one of the sources, the type is defined
agent.sources.netSrc.type = netcat
agent.sources.netSrc.bind= 127.0.0.1
agent.sources.netSrc.port= 9999
# The channel can be defined as follows.
agent.sources.netSrc.channels = memoryChannel
# Each sink's type must be defined
agent.sinks.avro-sink.type = avro
#Specify the channel the sink should use
agent.sinks.avro-sink.channel = memoryChannel
agent.sinks.avro-sink.hostname= 127.0.0.1
agent.sinks.avro-sink.port = 1000

agent.sinks.avro-sink.ssl=true
agent.sinks.avro-sink.trust-all-certs=true
agent.sinks.avro-sink.truststrore=/home/yuanhui0628/temp/mykeystore/truststore.jks
agent.sinks.avro-sink.truststrore-password=changeit
agent.sinks.avro-sink.truststrore-type=JKS
# Each channel's type is defined.
agent.channels.memoryChannel.type = memory
# Other config values specific to each type of channel(sink or source)
# can be defined as well
# In this case, it specifies the capacity of the memory channel
agent.channels.memoryChannel.capacity = 100 
```
