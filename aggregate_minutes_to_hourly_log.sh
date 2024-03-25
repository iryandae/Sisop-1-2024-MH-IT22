#!bin/bash/
log_time=$(date "+%Y%m%d%H")
log_save=metrics_agg_$log_time.log

for file in /home/user/log/*.log; do
	head -n 2 "$file" |tail -n 1 >> "/home/user/log/temp.log"
done
{
echo "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size"

echo "minimum," | tr -d '\n'
for i in {1..10}; do
	sort -t, -k$i,$i"n" "/home/user/log/temp.log" | cut -d, -f$i | head -n 1 | tr '\n' ","
done
sort -t, -k11,11n "/home/user/log/temp.log" | cut -d, -f11 | head -n 1

echo  "maximum," | tr -d '\n'
for i in {1..10}; do
	sort -t, -k$i,$i"nr" "/home/user/log/temp.log"| cut -d, -f$i | head -n 1 | tr '\n' ","
done
sort -t, -k11,11nr "/home/user/log/temp.log"| cut -d, -f11 | head -n 1

echo "average," | tr -d '\n'
for i in {1..10}; do
	awk -F"," '{print $i}' "/home/user/log/temp.log" | awk -F"," '{sum[i]+=$i} {sum[i]/NR;print $i}' | cut -d, -f$i | head -n 1 | tr '\n' ","
done
awk -F"," '{print $11}' "/home/user/log/temp.log" | awk -F"," '{sum[i]+=$i} {sum[i]/NR;print $i}' | cut -d, -f$i | head -n 1

} > "/home/user/log/$log_save"
chmod 400 "/home/user/log/$log_save"

rm "/home/user/log/temp.log"

#crontab config
#0 * * * * '/home/user/modul_1/soal_4:/aggregate_minutes_to_hourly_log.sh' 
