---
layout: post
category: tech
tagline: ""
tags : [java, threads]
comments: true
---
{% include JB/setup %}


```java
package ext.window.test;

import org.apache.samza.context.Context;
import org.apache.samza.context.TaskContext;
import org.apache.samza.metrics.Counter;
import org.apache.samza.storage.kv.KeyValueStore;
import org.apache.samza.system.IncomingMessageEnvelope;
import org.apache.samza.system.OutgoingMessageEnvelope;
import org.apache.samza.system.SystemStream;
import org.apache.samza.task.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicReferenceFieldUpdater;

/**
 * 当前Samza 版本中，Container 一个线程中 的 window()调用不会和一个process()同时发生调用
 */
public class FileDistributionStreamExchangeTask implements StreamTask, InitableTask, WindowableTask {

    private static final String counterGrp = "edit-counters";
    private static final String storeName1 = "wikipedia-stats1";
    private static final String storeName2 = "wikipedia-stats2";
    private static final String storeKey1 = "Hello1";
    private static final String storeKey2 = "Hello2";
    private static final SystemStream OUTPUT_STREAM = new SystemStream("kafka", storeName1);
    private static final String counterName1 = "repeat-edits1";
    private static final String counterName2 = "repeat-edits2";

    private DistributionStreamWorker worker1;
    private DistributionStreamWorker worker2;

    private long limits = 2000;

    private volatile DistributionStreamWorker cworker;
    private volatile AtomicReferenceFieldUpdater<FileDistributionStreamExchangeTask, DistributionStreamWorker> storeCAS =
            AtomicReferenceFieldUpdater.newUpdater(FileDistributionStreamExchangeTask.class,
                    DistributionStreamWorker.class,
                    "cworker");

    @Override
    public void init(Context context) throws Exception {
        TaskContext taskContext = context.getTaskContext();
        this.worker1 = new DistributionStreamWorker(storeKey1,
                taskContext.getTaskMetricsRegistry().newCounter(counterGrp,
                        counterName1), (KeyValueStore<String, List<String>>) taskContext.getStore(storeName1));
        this.worker2 = new DistributionStreamWorker(storeKey2,
                taskContext.getTaskMetricsRegistry().newCounter(counterGrp,
                        counterName2), (KeyValueStore<String, List<String>>) taskContext.getStore(storeName2));
        // cworker should be null, init once
        storeCAS.getAndSet(this, worker1);

    }

    @Override
    public void process(IncomingMessageEnvelope envelope, MessageCollector collector, TaskCoordinator coordinator) throws Exception {
        DistributionStreamWorker sWorker = cworker;
        while (sWorker.counter.getCount() >= limits) {// TODO 1
            // 高并发，没有机会获得CAS，更换到当前worker
            // TODO 2.
            if (sWorker == worker1) {
                if (!storeCAS.compareAndSet(this, worker1, worker2)) {
                    sWorker = cworker;
                    continue;
                }
            } else {
                if (!storeCAS.compareAndSet(this, worker2, worker1)) {
                    sWorker = cworker;
                    continue;
                }
            }
            sWorker.purge(collector, this.limits);
        }
        cworker.handleMsg(envelope);
    }


    @Override
    public void window(MessageCollector collector, TaskCoordinator coordinator) throws Exception {
        // Send the remains
        cworker.purge(collector, -1);
    }

    private static class DistributionStreamWorker {
        volatile Counter counter;
        volatile String batchInfo = null;
        KeyValueStore<String, List<String>> store;
        String storeKey;

        private DistributionStreamWorker(String storeKey, Counter counter, KeyValueStore<String, List<String>> store) {
            this.counter = counter;
            this.store = store;
            this.storeKey = storeKey;
        }

        public synchronized void purge(MessageCollector collector, long limit) {
            // TODO 3 == 1
            if (limit == -1 || counter.getCount() >= limit) {
                flush(collector);
                return;
            }
        }

        private void flush(MessageCollector collector) {
            collector.send(new OutgoingMessageEnvelope(OUTPUT_STREAM, this.store));
            this.store.delete(storeKey);
            counter.set(0l);
            batchInfo = "";
        }

        public synchronized void handleMsg(IncomingMessageEnvelope envelope) {
            Map<String, Object> edit = (Map<String, Object>) envelope.getMessage();
            List<String> arr = this.store.get(storeKey);
            if (arr == null) {
                arr = new ArrayList<>();
                this.store.put(storeKey, arr);
            }
            arr.add(edit.get("orderDetails").toString());
            // Update Batch here if possible
            batchInfo += 1;
            this.counter.inc();
        }

    }
}

```
