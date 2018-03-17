---
layout: post
category : tech
tagline: "Supporting tagline"
tags : [transaction, db_model]
---
{% include JB/setup %}

### TABLE GROUP
<table>
<thead>
<tr>
<td>ID</td>
<td>TASK_GROUP_NAME</td>
</tr>
</thead>
<tbody>
<tr><td>100</td><td>Make Java Coffee<code>import</code></td>
</tr>
<tbody>
</table>

### TABLE TASK
|ID|DESCRIPTION|TYPE|ARGS(json)|
|---|---|---|---|
|1000|Fetch the cups|RESTful|<code>{'url':'system/coffee/cups', 'color':'${color}, 'size':'16 Oz'}</code>|
|1001|Pour the powder|RESTful|<code>{'url':'system/coffee/powder', 'taste':'${dark}, 'quality':'${exellent}'</code>|


### TABLE TASK_ROLLBACK* (TBD)
|ID|TASK_ID|DESCRIPTION|TYPE|ARGS(json)|
|---|---|---|---|---|
|1|1000|Rollback Fetch cups|RESTful|<code>{'url':'system/coffee/rollback', 'by':'hand'}</code>|
|2|1001|Rollback pour the powder|RESTful|<code>{'url':'system/coffee/powder', 'by':'bottle'}</code>|


### TABLE TASK_GROUP_DEF
|ID|GROUP_ID|TASK_STEP_ID|TASK_ID|
|---|---|---|---|
|10000|100|1|1000|
|10001|100|2|1001|


### TABLE TASK_GROUP_REC
|ID|TASK_GROUP_ID|TASK_STEP_ID|CREATED_DATE|MODIFIED_DATE|STATUS|
|---|---|---|---|---|---|
|1|1|2|2018-01-01 01:00:00.0000|2018-01-01 01:00:01.0000|SUCCESS|
|2|1|1|2018-01-01 01:00:00.0000|2018-01-01 01:00:02.0000|IN_PROGRESS|
|3|1|2|2018-01-01 01:00:00.0000|2018-01-01 01:00:03.0000|FAIL|
|4|1|1|2018-01-01 01:00:00.0000|2018-01-01 01:00:04.0000|CANCELED|
|5|1|2|2018-01-01 01:00:00.0000|2018-01-01 01:00:05.0000|CANCELED_BY_USER|
|6|1|1|2018-01-01 01:00:00.0000|2018-01-01 01:00:06.0000|SHUTDOWN_IN_PROGRESS|
|7|1|2|2018-01-01 01:00:00.0000|2018-01-01 01:00:07.0000|SUSPEND|
|8|1|2|2018-01-01 01:00:00.0000|2018-01-01 01:00:08.0000|ROLLBACK|