---
layout: post
category: tech
tagline: ""
tags : [devops]
comments: true
---
{% include JB/setup %}

*scp.bat*
```
SET rootPath="C:\Program Files (x86)\WinSCP\"
SET folderDate=%date:~10,4%-%date:~4,2%-%date:~7,2%
mkdir e:\%folderDate%
SET localFilePath=e:\%folderDate%
%rootPath%\WinSCP.exe /console /script="C:\Users\yuanhui\Desktop\GetValidationData.txt"
```

*GetValidationData.txt*

```
option batch continue
option confirm off
option transfer binary
open sftp://user:psw@localhost:22
cd /data/streaming/%folderDate%
lcd %localFilePath%
get *
close
exit
```
