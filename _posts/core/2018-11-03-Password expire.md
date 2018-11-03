---
layout: post
category: tech
tagline: ""
tags : [devops, bash]
comments: true
---
{% include JB/setup %}

TODAY=`date "+%b %d, %Y"`
cat vmlist.txt|while read line;do
    EXPIRE_DATE=`ssh -n $line "chage -l wmuser|grep 'expires';exit"|tail|awk '{print $4,$5,$6}'`;
    echo $EXPIRE_DATE;
    echo $TODAY;
    t1=`date -d "$EXPIRE_DATE" +%s`;
    t2=`date -d "$TODAY" +%s`;
    if [ "$t1" -gt "$t2" ]; then
        echo "$EXPIRE_DATE > $TODAY"
    else
        echo "$TODAY > $EXPIRE_DATE"
    fi;
done;

