#!bin/bash/

log_time=$(date "+%Y%m%d%H%M%S")
log_save=metrics_$log_time.log

{
echo "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size"
free -m | tail -n 2 | awk 'BEGIN {RS=OFS=","} {$1="";$8="";sub(/^,/, "");sub(/,,/, ",");print}' | tr -d '\n'
echo -n ","
du -sh ~/ | awk '{print $2","$1}'
} > "/home/user/log/$log_save"

chmod 400 "/home/user/log/$log_save"

#crontab config
#* * * * * '/home/user/modul_1/soal_4:/minute_log.sh' 
