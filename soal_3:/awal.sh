#!/bin/bash

#download file
wget -O genshin.zip "https://drive.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN"

#unzip file
unzip genshin.zip -d genshin_character

#masuk direktori genshin_character
cd genshin_character || exit

#mendecode setiap nama file yang terenkripsi dengan hexadecimal
for file in *.zip; do
    unzip -P "$(basename "${file%.*}")" "$file"
    rm "$file"
done

#merename setiap file agar rapi
while IFS=',' read -r nama region elemen senjata; do
    for file in *.jpg; do
        if [[ "$file" == "$nama" ]]; then
            mv "$file" "$region - $nama - $elemen - $senjata.jpg"
        fi
    done
done < list_character.csv

#menghitung jumlah pengguna untuk setiap senjata
echo "Jumlah pengguna untuk setiap senjata:"
awk -F ',' 'NR > 1 {gsub(/^[ \t]+|[ \t]+$/, "", $4); print $4}' list_character.csv | sort | uniq -c | while read -r count senjata; do
    echo "$count : $senjata"
done

#hapus file yang tidak diperlukan
rm /home/satsujinki/sisopgenshin/genshin_character.zip
rm /home/satsujinki/sisopgenshin/genshin_character/list_character.csv
rm /home/satsujinki/sisopgenshin/genshin.zip
