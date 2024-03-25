#!/bin/bash

#fungsi untuk mencatat log
log() {
    echo "[$(date +'%d/%m/%y %H:%M:%S')] [$1] [$2]" >> image.log
}

#loop agar cek gambar setiap 1 detik
while true; do
    for image in *.jpg; do
        result=$(steghide extract -sf "$image" -p "" 2>&1)
        if [[ "$result" == "wrote" ]]; then
            log "FOUND" "$image"
            decrypted=$(xxd -p -c 99999 "${image%.*}.txt" | xxd -r -p)
            if [[ "$decrypted" == "http" ]]; then
                log "URL FOUND" "${image%.*}.txt"
                echo "URL ditemukan: $decrypted"
#download file dari URL
                wget -O secret_image.jpg "$decrypted"
#Menghentikan program search.sh
                exit 0
            else
                rm "${image%.*}.txt"
            fi
        else
            log "NOT FOUND" "$image" #gagal
        fi
    done
    sleep 1 #jeda sedetik
done
