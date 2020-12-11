#!/bin/bash
# cut nginx log files
# chmod +x /app/shell/cut_nginx_logs.sh
# 0 0 * * *  /bin/bash /app/shell/cut_nginx_logs.sh

#set the path to nginx log files（日志保存目录）
log_files_path="/app/log/nginx/"
log_files_dir=${log_files_path}

#set nginx log files you want to cut（需要分割的日志文件名，这是一个数组）
# log_files_name=(access.log access.log)

#gset the path to nginx.(nginx执行程序路径)
nginx_sbin="/usr/sbin/nginx"

#Set how long you want to save（日志分割后保存30天）
save_days=30

############################################
#Please do not modify the following script #
############################################
mkdir -p $log_files_dir

# 1. 按 log_files_name 文件名字来匹配
# log_files_num=${#log_files_name[@]}

# #cut nginx log files
# for((i=0;i<$log_files_num;i++));do
# mv ${log_files_path}${log_files_name[i]}.log ${log_files_dir}${log_files_name[i]}_$(date -d "yesterday" +"%Y-%m-%d").log
# done

# 2. 按文件夹匹配
cd $log_files_path  
today=$(date "+%Y%m%d")
for i in *.log  
do  
    mkdir -p ${today}
    mv $i ${today}/${today}-$i.log
    # tar zcf ${today}-${i}.tar.gz ${today}-$i && rm -f ${today}-$i
done

#delete 30 days ago nginx log files（只删除log文件，原来的脚本是删除所有30天前建立的文件，会把nginx.pid删除）
find $log_files_path/*/ -name '*.log' -mtime +$save_days -exec rm -rf {} \; 
# find $log_files_path -name "*.tar.gz" -mtime +15 -exec rm -f {} \;


#restart nginx
$nginx_sbin -s reload