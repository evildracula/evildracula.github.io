---
layout: post
category: tech
tagline: ""
tags : [streaming, java]
comments: true
---
{% include JB/setup %}

# Stream示例
```
package com.mavsplus.java8.turtorial.streams;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * java.util.Stream使用例子
 * 
 * 
 * java.util.Stream表示了某一种元素的序列，在这些元素上可以进行各种操作。Stream操作可以是中间操作，也可以是完结操作。
 * 完结操作会返回一个某种类型的值，而中间操作会返回流对象本身，并且你可以通过多次调用同一个流操作方法来将操作结果串起来。
 * Stream是在一个源的基础上创建出来的，例如java.util.Collection中的list或者set（map不能作为Stream的源）。
 * Stream操作往往可以通过顺序或者并行两种方式来执行。
 * 
 * 
 * public interface Stream<T> extends BaseStream<T, Stream<T>> {
 * <p>
 * 可以看到Stream是一个接口,其是1.8引入
 * 
 * <p>
 * Java 8中的Collections类的功能已经有所增强，你可以之直接通过调用Collections.stream()或者Collection.
 * parallelStream()方法来创建一个流对象
 * 
 * @author landon
 * @since 1.8.0_25
 */
public class StreamUtilExample {

    private List<String> stringList = new ArrayList<>();

    public StreamUtilExample() {
        init();
    }

    private void init() {
        initStringList();
    }

    /**
     * 初始化字符串列表
     */
    private void initStringList() {
        stringList.add("zzz1");
        stringList.add("aaa2");
        stringList.add("bbb2");
        stringList.add("fff1");
        stringList.add("fff2");
        stringList.add("aaa1");
        stringList.add("bbb1");
        stringList.add("zzz2");
    }

    /**
     * Filter接受一个predicate接口类型的变量，并将所有流对象中的元素进行过滤。该操作是一个中间操作，
     * 因此它允许我们在返回结果的基础上再进行其他的流操作
     * （forEach）。ForEach接受一个function接口类型的变量，用来执行对每一个元素的操作
     * 。ForEach是一个中止操作。它不返回流，所以我们不能再调用其他的流操作
     */
    public void useStreamFilter() {
        // stream()方法是Collection接口的一个默认方法
        // Stream<T> filter(Predicate<? super T>
        // predicate);filter方法参数是一个Predicate函数式接口并继续返回Stream接口
        // void forEach(Consumer<? super T> action);foreach方法参数是一个Consumer函数式接口

        // 解释:从字符串序列中过滤出以字符a开头的字符串并迭代打印输出
        stringList.stream().filter((s) -> s.startsWith("a")).forEach(System.out::println);
    }

    /**
     * Sorted是一个中间操作，能够返回一个排过序的流对象的视图。流对象中的元素会默认按照自然顺序进行排序，
     * 除非你自己指定一个Comparator接口来改变排序规则.
     * 
     * <p>
     * 一定要记住，sorted只是创建一个流对象排序的视图，而不会改变原来集合中元素的顺序。原来string集合中的元素顺序是没有改变的
     */
    public void useStreamSort() {
        // Stream<T> sorted();返回Stream接口
        // 另外还有一个 Stream<T> sorted(Comparator<? super T>
        // comparator);带Comparator接口的参数
        stringList.stream().sorted().filter((s) -> s.startsWith("a")).forEach(System.out::println);

        // 输出原始集合元素，sorted只是创建排序视图，不影响原来集合顺序
        stringList.stream().forEach(System.out::println);
    }

    /**
     * map是一个对于流对象的中间操作，通过给定的方法，它能够把流对象中的每一个元素对应到另外一个对象上。
     * 下面的例子就演示了如何把每个string都转换成大写的string.
     * 不但如此，你还可以把每一种对象映射成为其他类型。对于带泛型结果的流对象，具体的类型还要由传递给map的泛型方法来决定。
     */
    public void useStreamMap() {
        // <R> Stream<R> map(Function<? super T, ? extends R> mapper);
        // map方法参数为Function函数式接口(R_String,T_String).

        // 解释:将集合元素转为大写(每个元素映射到大写)->降序排序->迭代输出
        // 不影响原来集合
        stringList.stream().map(String::toUpperCase).sorted((a, b) -> b.compareTo(a)).forEach(System.out::println);
    }

    /**
     * 匹配操作有多种不同的类型，都是用来判断某一种规则是否与流对象相互吻合的。所有的匹配操作都是终结操作，只返回一个boolean类型的结果
     */
    public void useStreamMatch() {
        // boolean anyMatch(Predicate<? super T> predicate);参数为Predicate函数式接口
        // 解释:集合中是否有任一元素匹配以'a'开头
        boolean anyStartsWithA = stringList.stream().anyMatch((s) -> s.startsWith("a"));
        System.out.println(anyStartsWithA);

        // boolean allMatch(Predicate<? super T> predicate);
        // 解释:集合中是否所有元素匹配以'a'开头
        boolean allStartsWithA = stringList.stream().allMatch((s) -> s.startsWith("a"));
        System.out.println(allStartsWithA);

        // boolean noneMatch(Predicate<? super T> predicate);
        // 解释:集合中是否没有元素匹配以'd'开头
        boolean nonStartsWithD = stringList.stream().noneMatch((s) -> s.startsWith("d"));
        System.out.println(nonStartsWithD);
    }

    /**
     * Count是一个终结操作，它的作用是返回一个数值，用来标识当前流对象中包含的元素数量
     */
    public void useStreamCount() {
        // long count();
        // 解释:返回集合中以'a'开头元素的数目
        long startsWithACount = stringList.stream().filter((s) -> s.startsWith("a")).count();
        System.out.println(startsWithACount);

        System.out.println(stringList.stream().count());
    }

    /**
     * 该操作是一个终结操作，它能够通过某一个方法，对元素进行削减操作。该操作的结果会放在一个Optional变量里返回。
     */
    public void useStreamReduce() {
        // Optional<T> reduce(BinaryOperator<T> accumulator);
        // @FunctionalInterface public interface BinaryOperator<T> extends
        // BiFunction<T,T,T> {

        // @FunctionalInterface public interface BiFunction<T, U, R> { R apply(T
        // t, U u);
        Optional<String> reduced = stringList.stream().sorted().reduce((s1, s2) -> s1 + "#" + s2);

        // 解释:集合元素排序后->reduce(削减 )->将元素以#连接->生成Optional对象(其get方法返回#拼接后的值)
        reduced.ifPresent(System.out::println);
        System.out.println(reduced.get());
    }

    /**
     * 使用并行流
     * <p>
     * 流操作可以是顺序的，也可以是并行的。顺序操作通过单线程执行，而并行操作则通过多线程执行. 可使用并行流进行操作来提高运行效率
     */
    public void useParallelStreams() {
        // 初始化一个字符串集合
        int max = 1000000;
        List<String> values = new ArrayList<>();

        for (int i = 0; i < max; i++) {
            UUID uuid = UUID.randomUUID();
            values.add(uuid.toString());
        }

        // 使用顺序流排序

        long sequenceT0 = System.nanoTime();
        values.stream().sorted();
        long sequenceT1 = System.nanoTime();

        // 输出:sequential sort took: 51921 ms.
        System.out.format("sequential sort took: %d ms.", sequenceT1 - sequenceT0).println();

        // 使用并行流排序
        long parallelT0 = System.nanoTime();
        // default Stream<E> parallelStream() {
        // parallelStream为Collection接口的一个默认方法
        values.parallelStream().sorted();
        long parallelT1 = System.nanoTime();

        // 输出:parallel sort took: 21432 ms.
        System.out.format("parallel sort took: %d ms.", parallelT1 - parallelT0).println();

        // 从输出可以看出：并行排序快了一倍多
    }

    public static void main(String[] args) {
        StreamUtilExample example = new StreamUtilExample();

        example.useStreamFilter();
        example.useStreamMap();
        example.useStreamMatch();
        example.useStreamCount();
        example.useStreamReduce();
        example.useParallelStreams();
    }
}
```
  
  
## Map接口中新的默认方法示例
```
package com.mavsplus.java8.turtorial.streams;

import java.util.HashMap;
import java.util.Map;

/**
 * map是不支持流操作的。而更新后的map现在则支持多种实用的新方法，来完成常规的任务
 * 
 * @author landon
 * @since 1.8.0_25
 */
public class MapUtilExample {

    private Map<Integer, String> map = new HashMap<>();

    public MapUtilExample() {
        initPut();
    }

    /**
     * 使用更新后的map进行putIfAbsent
     */
    private void initPut() {
        // putIfAbsent为Map接口中新增的一个默认方法
        /**
         * <code>
                  default V putIfAbsent(K key, V value) {
                    V v = get(key);
                    if (v == null) {
                        v = put(key, value);
                    }

                    return v;
                  }
                  </code>
         */
        // 如果map中有对应K映射的V且不为null则直接返回;否则执行put
        for (int i = 0; i < 10; i++) {
            map.putIfAbsent(i, "value" + i);
        }

        // 放入了一个null元素
        map.putIfAbsent(10, null);
        // 替换null
        map.putIfAbsent(10, "value10");
        // 因为K-10有映射且不为null则忽略V-value11
        map.putIfAbsent(10, "value11");
    }

    /**
     * 使用更新后的map进行for-each
     */
    public void forEach() {
        // default void forEach(BiConsumer<? super K, ? super V> action)
        // Map接口中新增的默认方法

        // @FunctionalInterface public interface BiConsumer<T, U> {void accept(T
        // t, U u);
        map.forEach((id, val) -> System.out.println(val));
    }

    /**
     * 使用更新后的map进行compute——->重映射
     */
    public void compute() {
        // default V computeIfPresent(K key,BiFunction<? super K, ? super V, ?
        // extends V> remappingFunction)

        // Map接口中新增的默认方法

        // @FunctionalInterface public interface BiFunction<T, U, R> {R apply(T
        // t, U u);
        // --> V apply(K k,V v)

        // ifPresent会判断key对应的v是否是null，不会null才会compute->否则直接返回null

        // 解释:将K-3映射的value->compute->"value3" + 3 = value33
        map.computeIfPresent(3, (key, val) -> val + key);
        System.out.println(map.get(3));

        // 解释:这里将K-3映射的value进行重映射->null
        // 该方法源码实现会判断如果newValue为null则会执行remove(key)方法,将移除key
        map.computeIfPresent(9, (key, val) -> null);
        // 从上面的解释中得到，输出为false,因为已经被移除了
        System.out.println(map.containsKey(9));

        // default V computeIfAbsent(K key,Function<? super K, ? extends V>
        // mappingFunction)
        // 解释:代码实现上看，如果K-15映射的值为null,即不存在或者为null,则执行映射->所以本例来看(没有15的key)，该方法相当于插入一个新值
        map.computeIfAbsent(15, (key) -> "val" + key);
        System.out.println(map.containsKey(15));

        // 因为K-4映射的值存在，所以直接返回，即不会重映射,所以输出依然会是value4
        map.computeIfAbsent(4, key -> "bam");
        System.out.println(map.get(4));
    }

    /**
     * 使用更新后的map进行remove
     */
    public void remove() {
        // default boolean remove(Object key, Object value) {
        // Map接口中新增的默认方法

        // 其源码实现是
        // 1.当前key对应的值和传入的参数不一致时则直接返回，移除失败(用的是Objects.equals方法)
        // 2.当前key对应的值为null且!containsKey(key),移除失败(即当前map中根本不存在这个key_【因为有一种情况是有这个key但是key映射的值为null】)
        // ->否则执行移除

        /**
         * <code>
         *  default boolean remove(Object key, Object value) {
                Object curValue = get(key);
                if (!Objects.equals(curValue, value) ||
                    (curValue == null && !containsKey(key))) {
                    return false;
                }
                remove(key);
                return true;
            }
         * </code>
         */
        map.remove(3, "value4");
        System.out.println(map.get(3));

        // key和v匹配时则移除成功
        map.remove(3, "value33");
        System.out.println(map.get(3));
    }

    /**
     * getOrDefault是一个有用的方法
     */
    public void getOrDefault() {
        // default V getOrDefault(Object key, V defaultValue) {
        // Map接口中新增的默认方法

        /**
         * <code>
         * default V getOrDefault(Object key, V defaultValue) {
            V v;
            return (((v = get(key)) != null) || containsKey(key))
                ? v
                : defaultValue;
            }
         * </code>
         */

        // 源码实现:
        // 1.如果对应的key有value且不为null，则直接返回value;如果为null且包含该key，则返回null(总之即必须要有该key)
        // 2.如果没有该key，则用默认值
        String retV = map.getOrDefault("20", "not found");
        System.out.println(retV);

        // 加入一个null
        map.putIfAbsent(30, null);
        // 输出null
        System.out.println(map.get(30));
        // 输出null
        System.out.println(map.getOrDefault(30, "value30"));
    }

    /**
     * 合并
     */
    public void merge() {
        // default V merge(K key, V value,BiFunction<? super V, ? super V, ?
        // extends V> remappingFunction)

        // @FunctionalInterface public interface BiFunction<T, U, R> { R apply(T
        // t, U u);

        // merge为Map接口新增的默认方法

        /**
         * <code>
         default V merge(K key, V value,
            BiFunction<? super V, ? super V, ? extends V> remappingFunction) {
                Objects.requireNonNull(remappingFunction);
                Objects.requireNonNull(value);
                V oldValue = get(key);
                V newValue = (oldValue == null) ? value :
                           remappingFunction.apply(oldValue, value);
                if(newValue == null) {
                    remove(key);
                } else {
                    put(key, newValue);
                }
            return newValue;
         }
         * </code>
         */

        // 其源码实现:
        // 1.分别检查参数remappingFunction和value是否为null(调用Objects.requireNonNull).->为null则抛出空指针
        // 2.判断oldValue是否为null,如果为null则将传入的newValue赋值;如果oldValue不为null则执行merge函数
        // --->apply(oldValue, value)
        // 3.判断newValue->如果为null则执行移除；否则执行插入

        // k-9的值在执行compute方法的时候已经被移除了->所以oldValue为null->所以newValue为传入的参数value9->执行插入
        // 所以这里输出为value9
        String newValue1 = map.merge(9, "value9", (value, newValue) -> value.concat(newValue));
        System.out.println(newValue1);
        System.out.println(map.get(9));

        // k-9的值现在已经为value9了，所以执行merge函数->"value9".concat("concat")->newValue为"value9concat"
        // 执行插入，所以这里输出为value9concat
        String newValue2 = map.merge(9, "concat", (value, newValue) -> value.concat(newValue));
        System.out.println(newValue2);
        System.out.println(map.get(9));

        // k-8值存在为value8->执行merge函数->直接返回"NewMerge8"->newValue为"NewMerge8"
        // 执行put->所以这里输出"NewMerge8"
        map.merge(8, "merge", (value, newValue) -> "NewMerge8");
        System.out.println(map.get(8));
    }

    public static void main(String[] args) {
        MapUtilExample example = new MapUtilExample();

        example.forEach();
        example.compute();
        example.remove();
        example.getOrDefault();
        example.merge();
    }
}

```
