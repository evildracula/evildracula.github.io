---
layout: post
category: tech
tagline: "监控权限认证配置"
tags : [jdk]
comments: true
---
{% include JB/setup %}


#### JVM 启动配置
```
-Dcom.sun.management.jmxremote 
-Dcom.sun.management.jmxremote.port=1234
```


#### 配置用户及权限对应信息
`${JAVA_HOME}/jre/lib/management/jmxremote.access`  
```
somebody readwrite
monitorRole readonly
controlRole readwrite
```


#### User Informatio Config
`${JAVA_HOME}/jre/lib/management/jmxremote.password.template`  
```
somebody somebody_psw
monitorRole 123456
controlRole 123456
```


#### 启动生效
```
-Dcom.sun.management.jmxremote 
-Dcom.sun.management.jmxremote.port=1234
 
-Dcom.sun.management.jmxremote.authenticate=true
-Dcom.sun.management.jmxremote.password.file=jmxpassword
-Dcom.sun.management.jmxremote.access.file=jmxaccess
```