---
layout: post
category: tech
tagline: ""
tags : [threads]
comments: true
---
{% include JB/setup %}

`图上纠正：staticInt 会在不同线程同步，时机不确定，但是忙碌时候另外一个线程只能用本线程 staticInt 的copy`  
 ![Stream Arch](/resources/images/2018/4/1-static-volatile.png){:height="100%" width="100%"}  
 >static 静态部分  在类加载的时候会在类对象保留一份，此类的实例间共享一份静态资源，并加载到内存，寄存器，缓存，不保证每个线程看到的值是一致，最新值（假设有线程对静态变量修改的话）；而volatile表示每次保证读取到到是主内存中最新的值。  
>现在JVM经过优化，已不会出现liveness failure 。所以没事别用volatile。1.7前知名bug

<table>
<tr>
<td>原始代码</td>
<td>优化代码</td>
</tr>
<tr>
<td>
<code>while(!flag){}</code>
</td>
<td>
<code>if(flag){<br>
&nbps;&nbps;&nbps;&nbps;while(true){}<br>
    }</code>
</td>
</tr>
</table>

#### 死循环, 无volatile 关键字
```
public class TestWithoutVolatile {
    private static boolean bChanged;

    public static void main(String[] args) throws InterruptedException {
        new Thread() {
            @Override
            public void run() {
                for (;;) {
					if (bChanged == !bChanged) {
                        System.out.println("!=");
                        System.exit(0);
                    }
                }
            }
        }.start();
        Thread.sleep(300);
        new Thread() {
            @Override
            public void run() {
                for (;;) {
                    bChanged = !bChanged;
                }
            }
        }.start();
    }
}
```

#### 有volatile，正确感知
```
public class TestWithVolatile {
    private static volatile boolean bChanged;
    public static void main(String[] args) throws InterruptedException {
        new Thread() {
            @Override
            public void run() {
                for (;;) {
                    if (bChanged == !bChanged) {
                        System.out.println("!=");
                        System.exit(0);
                    }
                }
            }
        }.start();
        Thread.sleep(100);
        new Thread() {
            @Override
            public void run() {
                for (;;) {
                    bChanged = !bChanged;
                }
            }
        }.start();
    }
}
```


#### 测试代码
```
public class NoVisiblility {
    private static boolean ready;
    private static volatile boolean ready;// if $ready is volatile, this can be avoid as well even without $LINE 1
    private static int number;
    private static int cc;


    private static class ReaderThread extends Thread {
        public void run() { // 读线程
            while (!ready) {
                // $LINE 1
                System.out.println(222);// if this is removed, the copy of $ready will be used for ever
            }
            System.out.println(number);
            System.exit(0);
        }

    }

    private static class ReaderThread extends Thread {
        public void run() { // 读线程
            System.out.println("in");
            for (;;) {//  等价 while(!ready)
                // boolean aa = ready; 即使加入本变量 $aa 的读，也还是读取本地static copy
               // cc = 1; 即使加入其他变量的读写，也还是读取本地static copy
                // 如果执行ready = false; 就会同步$ready 在主存中的值，系统执行$LINE 2
                 if (ready) {
                    break; // $LINE 2
                }
            }
            System.out.println(number);
            System.out.println("exit");
            System.exit(0);
        }

    }


    public static void main(String[] args) throws InterruptedException { // 主线程
        new ReaderThread().start();
        Thread.sleep(10);
        new Thread(new Runnable() {

            @Override
            public void run() {
                for (;;) {
                    ready = true;
                    number = 42;
                }
            }
        }).start();;
    }
}
```