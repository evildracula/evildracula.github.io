---
layout: post
category: tech
tagline: ""
tags : [java, threads]
comments: true
---
{% include JB/setup %}


```java
package com.test.distrib;

import java.io.PrintStream;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicReferenceFieldUpdater;

public class FileDistributionStreamExchangeTask implements Runnable {

    private static final String counterGrp = "edit-counters";
    private static final String storeName1 = "wikipedia-stats1";
    private static final String storeName2 = "wikipedia-stats2";
    private static final String storeKey1 = "Hello1";
    private static final String storeKey2 = "Hello2";
    private static final PrintStream OUTPUT_STREAM = System.out;
    private static final String counterName1 = "repeat-edits1";
    private static final String counterName2 = "repeat-edits2";

    private DistributionStreamWorker worker1;
    private DistributionStreamWorker worker2;

    private static final long limits = 2000;

    private volatile DistributionStreamWorker cworker;
    private volatile AtomicReferenceFieldUpdater<FileDistributionStreamExchangeTask, DistributionStreamWorker> storeCAS =
            AtomicReferenceFieldUpdater.newUpdater(FileDistributionStreamExchangeTask.class,
                    DistributionStreamWorker.class,
                    "cworker");


    public FileDistributionStreamExchangeTask() {
        init();
    }

    public void init() {
        Map<String, Map<String, List<String>>> taskContext = new HashMap<>();
        taskContext.put(storeName1, new HashMap<>());
        taskContext.put(storeName2, new HashMap<>());
        this.worker1 = new DistributionStreamWorker(storeKey1, new AtomicLong(), taskContext.get(storeName1));
        this.worker2 = new DistributionStreamWorker(storeKey2, new AtomicLong(), taskContext.get(storeName2));
        // cworker should be null, init once
        storeCAS.getAndSet(this, worker1);
        Timer t = new Timer();
        t.schedule(new TimerTask() {
            @Override
            public void run() {
                window();
            }
        }, 0,100);

    }

    public void process(IncomingMessageEnvelope envelope) {
        // Check for limit
        DistributionStreamWorker sWorker = cworker;
        // sWorker 是cWorker的snapshot，只有当前counter满了才调用
        // 如果两个都limits了，先抢到的先发送
        while (sWorker.counter.get() >= limits) {// TODO 1
            // 高并发，没有机会获得CAS，更换到当前worker
            // TODO 2
            if (sWorker == worker1) {
                if (!storeCAS.compareAndSet(this, worker1, worker2)) {
                    sWorker = cworker;
                    System.out.println("Swap 1 - 2");
                    continue;
                }
            } else {
                if (!storeCAS.compareAndSet(this, worker2, worker1)) {
                    sWorker = cworker;
                    System.out.println("Swap 2 - 1");
                    continue;
                }
            }
            // 获得锁，发送当前 sWorker，是一个同步点
            sWorker.purge(this.limits);
        }
        cworker.handleMsg(envelope);
    }


    public void window() {
        // Send the remains
        System.out.println("window flush==============================");
        cworker.purge(-1);
    }

    @Override
    public void run() {

        while (true) {
            IncomingMessageEnvelope msg = new IncomingMessageEnvelope();
            Map<String, Object> map = new HashMap<>();
            map.put("orderDetails", "Generator " + Thread.currentThread().getId());
            msg.setMessage(map);
            map.put("" + System.currentTimeMillis(), "Thread " + Thread.currentThread().getId() + ": some msg");
            process(msg);
        }
    }

    private static class IncomingMessageEnvelope {
        private Map<String, Object> message;


        public Map<String, Object> getMessage() {
            return message;
        }

        public void setMessage(Map<String, Object> message) {
            this.message = message;
        }
    }


    private static class DistributionStreamWorker {
        volatile AtomicLong counter;
        volatile String batchInfo = null;
        Map<String, List<String>> store;
        String storeKey;

        private DistributionStreamWorker(String storeKey, AtomicLong counter, Map<String, List<String>> store) {
            this.counter = counter;
            this.store = store;
            this.storeKey = storeKey;
        }

        public synchronized void purge(long limit) {
            // TODO 3 互斥
            if (limit == -1 || counter.get() >= limit) {
                flush();
            }
        }

        private void flush() {
            OUTPUT_STREAM.println("Start to flush" + this.store.get("orderDetails"));
            this.store.remove(storeKey);
            counter.set(0l);
            batchInfo = "";
        }

        public synchronized void handleMsg(IncomingMessageEnvelope envelope) {
            System.out.println("Clean" + Thread.currentThread().getId());
            Map<String, Object> edit = envelope.getMessage();
            List<String> arr = this.store.get(storeKey);
            if (arr == null) {
                arr = new ArrayList<>();
                this.store.put(storeKey, arr);
            }
            String msg = edit.get("orderDetails").toString();
            long count = this.counter.get();
            if (count > limits+10) {
                System.err.println(count + "Out of limists!!!!");
                System.exit(0);
            }
            System.out.println("Total :" + count + "Current Consumer ===" + Thread.currentThread().getId() +
                    "+++++++++++" + msg);
            arr.add(msg);
            // Update Batch here if possible
            batchInfo += 1;
            this.counter.getAndIncrement();
        }

    }

    public static void main(String[] args) throws InterruptedException {
        final FileDistributionStreamExchangeTask t = new FileDistributionStreamExchangeTask();
        Thread[] tgroup = new Thread[10];
        for (int i = 0; i < tgroup.length; i++) {
            tgroup[i] = new Thread(t);
            tgroup[i].join();
        }
        for (int i = 0; i < tgroup.length; i++) {
            tgroup[i] = new Thread(t);
            tgroup[i].start();
        }

    }
}


```
