# Sisop-1-2024-MH-IT22
## Anggota Kelompok
- 5027231003  Chelsea Vania Hariyono (mengerjakan nomor 2)
- 5027231024  Furqon Aryadana (mengerjakan nomor 3)
- 5027231057  Elgracito Iryanda Endia (mengerjakan nomor 1 dan 4)
## Soal 1
Sebelum menampilkan data pembeli dengan total sales tertinggi, data perlu di susun menggunakan ```sort <delimiter> <kolom dan format sortir>``` dan kemudian ditampilkan data dengan urutan teratas dengan ```head <option> <jumlah baris>``` untuk baris yang diinginkan. 

Selain itu, untuk mencetak kolom yang diinginkan bisa dengan memotong tampilan data dengan command ```cut <delimiter> <nomor kolom>``` sehingga secara keseluruhan data akan terlihat seperti ini:
```shell
sort -t, -k17,17nr Sandbox.csv  | cut -d, -f6 | head -n 1
```
Menggunakan command line tersebut, akan diperoleh output yang hanya menampilkan nama pembeli tanpa mencetak data lain terkait pembeli tersebut.

Kemudian untuk menampilkan customer segment yang memiliki profit paling kecil. Kita bisa menggunakan command line yang serupa, tetapi kolom akan disusun dari yang terendah berdasarkan kolom profit sehingga command line yang digunakan akan terlihat seperti ini:
```shell
sort -t, -k20,20 Sandbox.csv | cut -d, -f7 | head -n 1
```
Untuk merapikan tampilan dan menyesuaikannya dengan format, bisa digunakan command sederhana seperti ```echo``` seperti ini:
```shell
#!/bin/bash

echo "top sales customer: "
sort -t, -k17,17nr Sandbox.csv  | cut -d, -f6 | head -n 1
echo -e "\n"

echo "least profit: "
sort -t, -k20,20 Sandbox.csv | cut -d, -f7 | head -n 1
echo -e "\n"
```
Pada kasus selanjutnya, diperlukan command ```awk``` untuk memperoleh nilai data profit dan menjumlahkannya sebelum dapat menampilkan kategori yang menghasilkan profit paling menguntungkan.

Setelah diperoleh jumlahnya, maka data dapat ditampilkan berdasarkan kategori yang paling menguntungkan
```shell
echo "profitable categories: "
awk -F',' '{arr[$14]+=$20} END {for (i in arr) print i, arr[i]}' Sandbox.csv | sed '3d'
echo -e "\n"
```
Untuk program yang terakhir, diminta untuk membuat fitur supaya pengguna bisa mengecek pesanan dari pelangan yang bisa dicari berdasarkan nama pelangan dan akan menampilkan data berupa *purchase date* dan *amount* dari pesanan yang dicari.

Pertama, kita memerlukan nama pembeli yang pesanannya ingin dicari. Maka, kita memerlukan input
```shell
echo "enter name to search: "
read search
```
Melalui input tersebut, kita akan membuat program untuk mengecek data yang ada pada file dan mencocokkan kolom nama dengan (untuk mengurangi error dalam input, program saya buat supaya tidak *case sensitive* sehingga kesalahan dalam pengetikan tidak akan terlalu mempengaruhi proses pencarian).
```shell
no_baris=$(grep -n -i "$search" Sandbox.csv | cut -d: -f1)
```
Jika ditemukan kecockan data, maka program akan menyimpan no baris dari data terkait pesanan pelanggan tersebut untuk kemudian ditampilkan data terkait *purchase date* dan *amount* dari pesanan yang dicari.
```shell
echo -e "\ndata found\n"
echo "purchase date: "
cut -d, -f2 Sandbox.csv | head -"$no_baris" | tail -n 1
echo "amount: "
cut -d, -f18 Sandbox.csv | head -"$no_baris" | tail -n 1
```

## Soal 2
Membuat folder penyimpanan file.
```shell
mkdir deux && cd deux
```
Selanjutnya membuat dan konfigurasi register.sh.
```shell
nano register.sh
```
Mengenkripsi password pengguna menggunakan metode base64.
```shell
#!/bin/bash
enc_user_password() {
echo -n "$1" | base64
}
```
Untuk menambahkan pengguna (user) baru, dan mengambil email, username, serta beberapa data lainnya.
```shell
user_regis() {
    local email=$1
    local username=$2
    local secure_q=$3
    local secure_a=$4
    local password=$5
    local user_type="user" 
```

Memeriksa apakah alamat email yang diberikan telah digunakan sebelumnya untuk mendaftar.
```shell
duplicate_email() {
    local email=$1
    grep -q "^$email:" account.txt
    return $?
}
```
Membuat user menjadi admin (memiliki akses-akses admin) jika pada email yang didaftarkan memiliki kata "admin".
```shell
if [[ "$email" == admin ]]; then
        user_type="admin"
    fi
```
Memeriksa apakah email telah terdaftar sebelumnya. Jika pernah, maka registrasi gagal.
```shell
enc_user_password=$(enc_user_password "$password")
duplicate_email "$email"
    if [ $? -eq 0 ]; then
        echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [Regitration Failed] Email $email already registered." >> auth.log
        echo "Email $email already registered. Please enter another email."
        exit 1
    fi
```
Memasukan data-data pengguna baru ke file "account.txt".
```shell
echo "$email:$username:$secure_q:$secure_a:$enc_user_password:$user_type" >> account.txt
```
Menghasilkan 2 macam output, jika tipe pengguna adalah admin maka akan terdaftar sebagai admin, jika tidak, akan terdaftar sebagai user biasa.
```shell
    if [[ $user_type == "admin" ]]; then
        echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [Registration Succeed] ADMIN $username registered successfully." >> auth.log
        echo "ADMIN $username registered successfully."
    else
        echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [Registration Succeed] User $username registered successfully." >> auth.log
        echo "User $username registered successfully."
    fi
}
```
Menu utama yang akan muncul saat menu "register.sh" dijalankan.
```shell
##MAIN MENU#
echo "===== Registration ====="
read -p "Email: " email
read -p "Username: " username
read -p "Security Question: " secure_q
read -p "Security Answer: " secure_a
read -sp "Password: " password
echo
```
Memastikan password yang dibuat memenuhi kriteria; minmal 8 karakter yang memiliki minimal 1 huruf kapital dan 1 angka. Jika salah satu dari kriteria tidak terpenuhi, pesan kesalahan akan dicetak dan pengguna diminta untuk membuat ulang password. Jika password memenuhi semua kriteria, loop akan dihentikan, dan proses akan dilanjutkan.
```shell
while true; do
    if [[ ${#password} -lt 8 || !("$password" =~ [[:lower:]]) || !("$password" =~ [[:upper:]]) || !("$password" =~ [0-9]) ]]; then
        echo "Password must be at least 8 characters, contain at least one uppercase, one lowercase, and one number."
        read -sp "Password: " password
        echo
    else
        break
    fi
done
```
Mendaftarkan pengguna baru dengan informasi yang diberikan ke dalam file "account.txt" dengan format yang telah ditentukan.
```shell
user_regis "$email" "$username" "$secure_q" "$secure_a" "$password"
```
![WhatsApp Image 2024-03-30 at 22 53 06_8014d278](https://github.com/iryandae/Sisop-1-2024-MH-IT22/assets/151121570/2483665c-924a-4bd5-9978-4daafc4f6566)

Selanjutnya membuat dan konfigurasi login.sh.
```shell
nano login.sh
```
Mengambil bagian string yang dienkripsi menggunakan base64, dan mengembalikan password asli dalam bentuk teks.
```shell
#!/bin/bash
decrypt_user_password() {
    echo "$1" | base64 -d
}
```
Membuat fungsi untuk mengecek status akun yang dibuat/apakah variabel yang diinputkan sudah pernah dipakai.
```shell
check_credentials() {
    local email=$1
    local password=$2
    local saved_password=$(grep "^$email:" account.txt | cut -d: -f5)
    local is_admin=$(grep "^$email:" account.txt | cut -d: -f6)
```
Menyimpan password yang dimasukkan, membandingkan kondisi; jika cocok, maka mengembalikan nilai 0, (password benar). Jika tidak cocok, akan mengembalikan nilai 1 (password salah).
```shell
saved_decrypt_password=$(decrypt_user_password "$saved_password")

    if [ "$password" == "$saved_decrypt_password" ]; then
        return 0
    else
        return 1
    fi
}
```
Pada kasus seperti pengguna yang lupa password, akan dberikan opsi ini, password dapat dilihat dengan menjawab pertanyaan keamanan yang dimasukkan saat mendaftarkan akun. Jika jawaban yang dimasukkan benar, maka password yang disimpan untuk email tersebut di-dekripsi oleh decrypt_user_password(), kemudian akan ditampilkan kepada pengguna. 
```shell
forgot_password() {
    local email=$1
    local secure_q=$(grep "^$email:" account.txt | cut -d: -f3)
    local correct_answer=$(grep "^$email:" account.txt | cut -d: -f4)

    echo "Security Question: $secure_q"
    read -p "Security Answer: $secure_a" user_answer
if [ "$user_answer" == "$correct_answer" ]; then
        local saved_password=$(grep "^$email:" account.txt | cut -d: -f5)
        saved_decrypt_password=$(decrypt_user_password "$saved_password")
        echo "Your password is: $saved_decrypt_password"
    else
        echo "Incorrect answer."
    fi
}
```
Beberapa tindakan/akses yang dimiliki oleh tipe pengguna admin, opsi 1, 2, dan 3 akan mengarahkan pada file lain; register.sh, edit.sh, dan delete.sh. Sedangkan di luar opsi tersebut akan mengeluarkan pesan tindakan tidak valid.
```shell
admin_actions() {
    echo "Admin Actions:"
    echo "1. Add User"
    echo "2. Edit User"
    echo "3. Delete User"
    read -p "Choose action: " action

    case $action in
        1)
            ./register.sh
            ;;
        2)
            ./edit.sh
            ;;
        3)
            ./delete.sh
            ;;
        *)
            echo "Invalid action"
            ;;
	esac
}
```
Menu utama saat menjalankan login.sh
```shell
##MAIN MENU#
echo "===== Login ====="
echo "1. Login"
echo "2. Forgot Password"
read -p "Choose option: " option
```
Pengguna diminta untuk memasukkan alamat email dan password, kemudian skrip akan mencari email yang cocok dalam file "account.txt". Jika tidak ditemukan, sebuah pesan kesalahan dicetak dan program berhenti. Jika alamat email ditemukan, skrip menggunakan fungsi check_credentials(), jika cocok, pengguna berhasil masuk dan berhasil dicatat. 
```shell
case $option in
    1)
        read -p "Email: " email
        read -sp "Password: " password
        echo

        grep -q "^$email:" account.txt
        if [ $? -ne 0 ]; then
            echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [LOGIN FAILED] ERROR: Email $email not found." >> auth.log
            echo "ERROR: Email $email not found."
            exit 1
        fi

        check_credentials "$email" "$password"
        if [ $? -eq 0 ]; then
            echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [LOGIN SUCCESS] User with $email successfuly logged in ." >> auth.log
```
Jika alamat email memiliki tipe "admin", akan menampilkan menu tindakan admin. 
```shell
            if [[ $email == "admin" ]]
                then
                admin_actions
            else
                echo "Login successful! No admin privileges."
            fi
```
![WhatsApp Image 2024-03-30 at 22 54 25_b2aaf0c1](https://github.com/iryandae/Sisop-1-2024-MH-IT22/assets/151121570/fbbb79ff-9776-4335-b1fe-895a56663edd)

Jika password tidak cocok, pengguna akan ditanya mengenai lupa password. Jika memilih "Y", fungsi forgot_password() dijalankan.
```shell
        else
            echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [LOGIN FAILED] ERROR: Incorrect password for $email." >> auth.log
            echo "ERROR: Incorrect password."
            read -p "Forgot Password? (Y/N): " choice
            if [ "$choice" == "Y" ]; then
                forgot_password "$email"
            fi
        fi
        ;;
```
Opsi ke-2, jika pengguna ingin (langsung) mengatur ulang password.
```shell
    2)
        read -p "Enter your email: " email
        forgot_password "$email"
        ;;
```
Opsi lain tidak valid
```shell
    *)
        echo "Invalid option"
        ;;
esac
```
Tambahan untuk opsi edit dan delete yang dibuat terpisah agar tidak perlu login ulang. Menggunakan email karena sebelumnya saat menggunakan username, yang terpanggil adalah username pada program laptop.
```shell
nano edit.sh
#!/bin/bash
edit() {
    read -p "Enter email to edit: " email
    if grep -q "^$email:" /etc/passwd; then
        read -p "Enter new details for user with the email $email: " new_infos
        echo "User with the email $email edited successfully with details: $new_details"
    else
        echo "User with the email $email does not exist"
    fi
}
edit
```
```shell
nano delete.sh
delete() {
    read -p "Enter email to delete: " email
    if grep -q "^$email:" account.txt; then
        sed -i "/^$email\$/d" account.txt
        echo "User with the email $email deleted successfully"
    else
        echo "User with the email $email does not exist"
    fi
}
delete
```
KENDALA yang dialami:
1. Saat memasukan detail baru, belum bisa mengganti satu per satu.
![WhatsApp Image 2024-03-30 at 22 58 03_5cb39273](https://github.com/iryandae/Sisop-1-2024-MH-IT22/assets/151121570/712af667-e5b7-43f1-b9b0-6dfce286d532)
2. Error saat menghapus user
![WhatsApp Image 2024-03-30 at 22 59 23_f99f16cb](https://github.com/iryandae/Sisop-1-2024-MH-IT22/assets/151121570/74c16ee8-deda-4c03-8a2c-9bff640e9498)
![WhatsApp Image 2024-03-30 at 19 12 15_556a38de](https://github.com/iryandae/Sisop-1-2024-MH-IT22/assets/151121570/fe223b62-c79b-4265-8a97-7f302828d3d5)
3. Semua pengguna (termasuk bukan admin) bisa menggunakan opsi edit dan delet karena filenya disendirikan, masih kesulitan untuk mencari langkah yang tepat.
![WhatsApp Image 2024-03-30 at 19 11 19_75f2ab1b](https://github.com/iryandae/Sisop-1-2024-MH-IT22/assets/151121570/fa552f04-eb1c-4266-9361-1655bd4420c0)

## Soal 3
Untuk mempermudah, buat direktori untuk menyimpan skrip, download file,enkripsi file.
```shell
mkdir sisopgenshin && cd sisopgenshin
```
Kemudian membuat skrip awal.sh dan mengkonfigurasi awal.sh.
```shell
touch awal.sh && nano awal.sh
```
Setelah itu, gunakan perintah wget untuk mengunduh file, gunakan opsi -O untuk menyimpan file dengan nama genshin.zip.
```shell
wget -O genshin.zip "https://drive.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN"
```
Unzip file dengan command ``unzip`` dan opsi ``-d`` untuk menentukan direktori tujuan ekstraksi.
```shell
unzip genshin.zip -d genshin_character
```
Masuk ke direktori genshin_character menggunakan command ``cd`` dan gunakan or ``exit`` apabila direktori tidak ditemukan.
```shell
cd genshin_character || exit
```
Lakukan dekode pada setiap file yang terenkripsi dengan menggunakan metode hexadecimal. Setiap file zip akan diekstrak dengan menggunakan password yang diambil dari nama file itu sendiri (tanpa ekstensi).
```shell
for file in *.zip; do
    unzip -P "$(basename "${file%.*}")" "$file"
    rm "$file"
done
```
Dengan menggunakan data dari file CSV untuk mengubah nama setiap file gambar agar lebih rapi. Nama file dipisahkan berdasarkan koma (,), dan kemudian digunakan untuk mengganti nama file JPG yang sesuai.
```shell
while IFS=',' read -r nama region elemen senjata; do
    for file in *.jpg; do
        if [[ "$file" == "$nama" ]]; then
            mv "$file" "$region - $nama - $elemen - $senjata.jpg"
        fi
    done
done < list_character.csv
```
Menghitung jumlah pengguna untuk setiap senjata berdasarkan data dari file CSV. Ini mencetak jumlah pengguna untuk masing-masing senjata yang diurutkan dan dihitung menggunakan ``awk``, ``sort``, dan ``uniq``.
dan kemudian digunakan untuk mengganti nama file JPG yang sesuai.
```shell
echo "Jumlah pengguna untuk setiap senjata:"
awk -F ',' 'NR > 1 {print $4}' list_character.csv | sort | uniq -c | while read -r count senjata; do
    echo "$count : $senjata"
done
```
Untuk menghemat penyimpanan hapus file-file yang tidak diperlukan.
```shell
rm /home/satsujinki/sisopgenshin/genshin_character.zip
rm /home/satsujinki/sisopgenshin/genshin_character/list_character.csv
rm /home/satsujinki/sisopgenshin/genshin.zip
```
Jalankan skrip dengan ``chmod +x`` untuk mengubah izin file dan direktori
```shell
chmod +x awal.sh && ./awal.sh
```

<img width="992" alt="Screenshot 2024-03-30 at 15 06 50" src="https://github.com/iryandae/Sisop-1-2024-MH-IT22/assets/150358232/bb7a61a3-6892-4e44-97a2-938cb8c32592">


Untuk menemukan secret picture diperlukan skrip baru bernama search.sh 
```shell
touch search.sh && nano search.sh
```
Buat fungsi untuk mencatat log.
```shell
log() {
    echo "[$(date +'%d/%m/%y %H:%M:%S')] [$1] [$2]" >> image.log
}
```
Fungsi ini bertanggung jawab untuk mencatat pesan log ke dalam file image.log dengan format yang ditentukan.
Kemudian buat loop utama yang akan akan berjalan tanpa henti.
```shell
while true; do
    (isi loop)
done

```
Setelah itu buat loop untuk mengecek setiap file dengan ekstensi .jpg di direktori tempat skrip berjalan dengan jeda 1 detik
```shell
for image in *.jpg; do
    (isi loop)
done
sleep 1
```
Dalam loop ``for image`` lakukan ekstraksi pesan tersembunyi dengan steghide.
```shell
result=$(steghide extract -sf "$image" -p "" 2>&1)
```
Periksa hasil ekstraksi. Jika berhasil, lanjutkan; jika tidak, lanjutkan ke gambar berikutnya. Catat pesan log "FOUND" jika data tersembunyi ditemukan dalam gambar. Lakukan dekripsi teks yang diekstrak dari gambar. Teks yang sebelumnya diubah menjadi representasi hexadesimal lalu dikonversi kembali menjadi teks biasa. Kemudian asil dekripsi disimpan dalam variabel decrypted.
```shell
    if [[ "$result" == "wrote" ]]; then
            log "FOUND" "$image"
            decrypted=$(xxd -p -c 99999 "${image%.*}.txt" | xxd -r -p)
                (isi kode)
    else
            log "NOT FOUND" "$image"
    fi
```
Periksa apakah teks yang didekripsi mengandung string "http". Jika true tampilkan URL dan unduh URL kemudian ``exit`` dari program, jika false hapus file teks yang diekstrak.
```shell
   if [[ "$decrypted" == "http" ]]; then
                log "URL FOUND" "${image%.*}.txt"
                echo "URL ditemukan: $decrypted"
                wget -O secret_image.jpg "$decrypted"
                exit 0
            else
                rm "${image%.*}.txt"
```
Jalankan skrip dengan ``chmod +x`` untuk mengubah izin file dan direktori
```shell
chmod +x search.sh && ./search.sh
```
<img width="992" alt="Screenshot 2024-03-30 at 15 43 02" src="https://github.com/iryandae/Sisop-1-2024-MH-IT22/assets/150358232/e6104af0-04da-4b31-8de9-f4bafa6cc384">
<img width="1093" alt="Screenshot 2024-03-30 at 15 43 26" src="https://github.com/iryandae/Sisop-1-2024-MH-IT22/assets/150358232/e4906289-d0af-4b1c-b6e6-d51b8e473c16">

Kendala yang dialami:
1. Setelah menjalankan awal.sh file genshin_character.zip tidak ditemukan.
2. Output dari awal.sh tidak bisa menampilkan [Nama Senjata] : [jumlah]
namun bisa menampilkan jumlah] : [Nama Senjata]
3. Image.log berhasil dibuat dan menuliskan output yang sesuai namun secret picture tidak berhasil ditemukan

## Soal 4
Data metrics yang dihasilkan akan disimpan ke dalam file dengan format nama metrics_{YmdHms}.log dengan {YmdHms} merupakan waktu disaat file script bash dijalankan. Dalam pengerjaan, saya menyimpan format nama file tersebut menjadi suatu variable agar lebih mudah digunakan sehingga command line yang akan digunakan dalam file ```minute_log.sh``` akan terlihat seperti ini:
```shell
log_time=$(date "+%Y%m%d%H%M%S")
log_save=metrics_$log_time.log
```
dan untuk ```file aggregate_minutes_to_hourly.sh``` menjadi
```shell
log_time=$(date "+%Y%m%d%H")
log_save=metrics_agg_$log_time.log
```
Untuk mencatat output dari command ```free -m``` mengubahnya menjadi format yang diinginkan dan menyimpannya dalam file yang sudah ditetapkan, dapat digunakan command sebagai berikut
```shell
{
echo "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size"
free -m | tail -n 2 | awk 'BEGIN {RS=OFS=","} {$1="";$8="";sub(/^,/, "");sub(/,,/, ",");print}' | tr -d '\n'
echo -n ","
du -sh ~/ | awk '{print $2","$1}'
} > "/home/user/log/$log_save"
```
command ```{...} > <path/file name>``` digunakan untuk menyimpan output perintah yang dilakukan dalam *bracket* ke dalam file yang ditentukan. Cara yang sama juga saya gunakan untuk file kedua.

command ```awk``` digunakan untuk mengambil output dari ```free -m``` dan mengubahnya sesuai dengan format yang diinginkan. Dalam command line ini, format yang diinginkan direpresentasikan dengan 
```shell
'BEGIN {RS=OFS=","} {$1="";$8="";sub(/^,/, "");sub(/,,/, ",")
```
kemudian diakhiri dengan perintah ```print``` dan command ```tr -d '\n'``` untuk menghilangkan next line di bagian akhir output ```free -m```. Hal serupa juga digunakan untuk menyusun format dari output command ```du -sh ~/```

Di dalam file aggregasi, untuk mengabungkan data dari log per menit, digunakan command loop untuk setiap file dengan format ```.log``` dalam directory ```/home/user/log``` dan untuk setiap filenya hanya diambil data pada baris ke 2 yang merupakan baris yang berisi data dari command yang sudah dijalankan sebelumnya.
```shell
for file in /home/user/log/*.log; do
	head -n 2 "$file" |tail -n 1 >> "/home/user/log/temp.log"
done
```
Data-data yang disatukan ditulis ulang dalam file *temporary*

Setelah memiliki kumpulan data, untuk mencari data minimum dan maksimum dapat digunakan loop untuk setiap kolom dari data yang ada. Data tersebut akan disusun berdasarkan terkecil dan/ataupun terbesar sesuai dengan ketentuan. Setelah tersusun, data teratas akan disimpan ke dalam file dengan format penulisan sesuai dengan yang sudah ditentukan.
```shell
for i in {1..10}; do
	sort -t, -k$i,$i"n" "/home/user/log/temp.log" | cut -d, -f$i | head -n 1 | tr '\n' ","
done
sort -t, -k11,11n "/home/user/log/temp.log" | cut -d, -f11 | head -n 1

echo  "maximum," | tr -d '\n'
for i in {1..10}; do
	sort -t, -k$i,$i"nr" "/home/user/log/temp.log"| cut -d, -f$i | head -n 1 | tr '\n' ","
done
sort -t, -k11,11nr "/home/user/log/temp.log"| cut -d, -f11 | head -n 1
```
Sedangkan, untuk mencari *average* dari kumpulan data tersebut, dapat digunakan command ```awk``` untuk setiap kolomnya untuk menjumlahkan nilai per kolom dan membaginya sesuai jumlah yang ada untuk menghasilkan nilai rata-rata.
```shell
echo "average," | tr -d '\n'
for i in {1..10}; do
	awk -F"," '{print $i}' "/home/user/log/temp.log" | awk -F"," '{sum[i]+=$i} {sum[i]/NR;print $i}' | cut -d, -f$i | head -n 1 | tr '\n' ","
done
awk -F"," '{print $11}' "/home/user/log/temp.log" | awk -F"," '{sum[i]+=$i} {sum[i]/NR;print $i}' | cut -d, -f$i | head -n 1
```
Setelah semua proses selesai, dan output sudah disimpan ke dalam file dengan cara yang sama seperti sebelumnya. File *temporary* dari kumpulan file akan dihapuskan
```shell
rm "/home/user/log/temp.log"
```
Lalu, untuk mengubah akses file supaya file log tadi hanya dapat diakses oleh *user* yang membuatnya digunakan command
```shell
chmod 400 "/home/user/log/$log_save"
```
Dan yang terakhir, untuk menjalankan file secara otomatis, untuk setiap menitnya bisa digunakan konfigurasi crontab seperti berikut:
```shell
* * * * * '/home/user/modul_1/soal_4:/minute_log.sh' 
```
dan untuk setiap jamnya dapat menggunakan konfigurasi berikut:
```shell
0 * * * * '/home/user/modul_1/soal_4:/aggregate_minutes_to_hourly_log.sh' 
```
