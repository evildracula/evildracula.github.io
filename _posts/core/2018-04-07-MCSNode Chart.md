---
layout: post
category: tech
tagline: ""
tags : [threads]
comments: true
---
{% include JB/setup %}

#### 时序解析

1. 线程顺序  
  
|Thread|Predecossor|Currrent|Next|
|:---:|:---:|:---:|:---:|
|T1|P=null >> P=C1|C1|C1.next =NULL|
|T2|P=C1|C2|C1.next = C2|
|T3|P=C2|C3|C2.next = C3|
  
    
2. 代码详解  
  
```
T1 & T2
def Lock {
    P = GAS(C1) // P == NULL
}

def Unlock {
    if (c1.next == null) {
        if CAS(C1, NULL) { // T2 情况
            // 确实C1.next == null，因为如果执行过
            // T2 Lock: P = GAS(C2)
            // P = C2, 则CAS(C1, NULL)失败
            return; // 未执行 T2 Lock: P = GAS(C2)
        } else { // T2 情况
            // 确实C1.next == null，因为如果执行过
            // T2 Lock: P = GAS(C2)
            // P = C2, 则CAS(C1, NULL)失败
            while (C1.next == null) { // T2 情况
                // 等待next 挂载 C1.next = C2
            }
        }
    }
    // C1.next != null
    C1.next.isBlock = false; // 执行 T2 的 lock
    c1.next = null // GC
}
```

 ![MSC Node 时序图](/resources/images/2018/4/2-MCSNode.png){:height="100%" width="100%"}  
