#!/bin/bash

##CPU负载计算
function GetSysCPU
{
  CpuIdle=`vmstat 1 5 |sed -n '3,$p' | awk '{x = x + $15} END {print x/5}' | awk -F. '{print $1}'`
  CpuNum=`echo "100-$CpuIdle" | bc`
  echo $CpuNum
}

function GetMem
     {
         MEMUsage=`ps -o vsz -p $1|grep -v VSZ`
         (( MEMUsage /= 1000))
      echo $MEMUsage
}

function Notify(){
## 企业微信
curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=71bba814-b98d-4fd6-83d2-7a04bb7d669e' \
   -H 'Content-Type: application/json' \
   -d '{
        "msgtype": "text",
        "text": {
            "content": "'${1}'"
        }
   }'
## telegram
# curl -X POST "https://api.telegram.org/bot892800444:AAEF2b4NH1VGAYnrGNS060KJwCVYYDBmJQ0/sendMessage?chat_id=179231572&text=$date%0aCPU负载为$cpucheck%%0a注意及时检查%0a如果该警报持续...%0a或联系管理员%0a"
}


cpucheck=`GetSysCPU` #将结果输出赋值到cpucheck
cpumax=50 #CPU触警阈值
memmax=

# 常用变量
curTime=$(env LANG=en_US.UTF-8 date "+%Y-%m-%d_%H:%M:%S") #当前时间赋值
hostname=$(hostname)

msg="${curTime}|${hostname}|CPU负载为${cpucheck}%_注意及时检查_如果该警报持续请联系管理员"
if [ ${cpucheck} -gt $cpumax ]; #阈值与实际CPU值进行对比
then
Notify ${msg}
else
#监测坚果输出到本地以便后期查阅..
echo "${msg}" > /tmp/cpucheck.log 
fi