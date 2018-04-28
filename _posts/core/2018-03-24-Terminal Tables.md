---
layout: post
category: tech
tagline: ""
tags : [java, tools, terminal]
comments: true
---
{% include JB/setup %}
#### 终端表格视图
<pre>
+--------------------+-------------------+-------------------+
|Radom1              |Random2            |Random3            |
+--------------------+-------------------+-------------------+
|0.06755062834736865 |0.4542417683796922 |1.1586158719580555 |
+--------------------+-------------------+-------------------+
|-0.24271531203031793|1.0407668925262665 |0.09440602664740765|
+--------------------+-------------------+-------------------+
|-1.3215618679041439 |1.4212664065598843 |0.2942535957573404 |
+--------------------+-------------------+-------------------+
|-0.4126871642299408 |-1.9364842330008802|0.04987604231448549|
+--------------------+-------------------+-------------------+
|-0.921067143998517  |1.008722630792641  |0.22924724078761508|
+--------------------+-------------------+-------------------+
</pre>

#### 详细代码
```java
package ext.hello;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class DrawTable {

	final String TAB = "    ";
	final String SPACE = " ";
	final String RT = "\n";
	final char NODE = '+';
	final char DASH = '-';
	final char SEP = '|';
	private String title = "";
	private String[] header = null;
	private List<List<String>> data = null;

	public DrawTable(String title, String[] header, List<List<String>> data) {
		this.data = data;
		this.header = header;
		this.title = title;
	}

	public String draw() {
		StringBuffer sb = new StringBuffer();
		StringBuffer sb1 = new StringBuffer();
		StringBuffer bottom = new StringBuffer();
		int COL = header.length;
		Map<Integer, List<String>> dataRowMap = new HashMap<>();
		int[][] colHWPair = new int[COL][2];
		preHeaderWidth(COL, dataRowMap, colHWPair);
		writeHeader(sb, sb1, bottom, COL, colHWPair);
		writeRecord(sb, bottom, COL, colHWPair);
		return sb.toString();
	}

	private void writeRecord(StringBuffer sb, StringBuffer bottom, int COL, int[][] colHWPair) {
		StringBuffer sb1;
		for (List<String> rec : data) {
			sb1 = new StringBuffer();
			sb1.append(SEP);
			for (int i = 0; i < COL; i++) {
				int[] pair = colHWPair[i];
				String d = rec.get(i);
				sb1.append(d);
				for (int j = d.length(); j < pair[0]; j++) {
					sb1.append(SPACE);
				}
				sb1.append(SEP);
			}
			sb1.append(RT).append(bottom.toString()).append(RT);
			sb.append(sb1.toString());
		}
	}

	private void writeHeader(StringBuffer sb, StringBuffer sb1, StringBuffer bottom, int COL, int[][] colHWPair) {
		bottom.append(NODE);
		sb1.append(SEP);
		for (int i = 0; i < COL; i++) {
			// Write Dash
			int[] pair = colHWPair[i];
			for (int j = 0; j < pair[0]; j++) {
				bottom.append(DASH);
			}
			bottom.append(NODE);
			sb1.append(header[i]);
			for (int j = header[i].length(); j < pair[0]; j++) {
				sb1.append(SPACE);
			}
			sb1.append(SEP);
		}
		sb.append(bottom.toString()).append('\n').append(sb1.toString()).append('\n').append(bottom.toString())
		  .append(RT);
	}

	private void preHeaderWidth(int COL, Map<Integer, List<String>> dataRowMap, int[][] colHWPair) {
		for (int i = 0; i < COL; i++) {
			String head = header[i];
			List<String> dataListCol = dataRowMap.get(i);
			if (dataListCol == null) {
				dataListCol = new ArrayList<>();
				dataRowMap.put(i, dataListCol);
			}
			colHWPair[i][0] = head.length();
			colHWPair[i][1] = 1;
			for (List<String> dataRec : data) {
				String colData = dataRec.get(i);
				int w = 0;
				int h = 0;
				if (!(colData == null || "".equals(colData))) {
					int size = colData.length();
					w = size;
					h = 1;
				}
				colHWPair[i][0] = w > colHWPair[i][0] ? w : colHWPair[i][0];
				colHWPair[i][1] = h > colHWPair[i][1] ? w : colHWPair[i][1];
				dataListCol.add(colData);
			}
		}
	}

	public static void main(String[] args) {
		String title = "HelloWorld";
		String[] header = new String[] {"Radom1", "Random2", "Random3"};
		int COL = header.length;
		Random r = new Random(System.currentTimeMillis());
		int DATA_LEN = 5;
		List<List<String>> data = new ArrayList<>();
		for (int i = 0; i < DATA_LEN; i++) {
			List<String> rec = new ArrayList<>();
			for (int j = 0; j < COL; j++) {
				rec.add(r.nextGaussian() + "");
			}
			data.add(rec);
		}
		System.out.println(new DrawTable(title, header, data).draw());

	}

}
```
