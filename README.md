# Sisop-1-2024-MH-IT22
## Anggota Kelompok
- 5027231003  Chelsea Vania Hariyono
- 5027231024  Furqon Aryadana
- 5027231057  Elgracito Iryanda Endia
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
## Soal 3
Untuk mempermudah,buat direktori untuk menyimpan skrip,download file.enkripsi file.
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
<img width="992" alt="Screenshot 2024-03-30 at 15 06 50" src="https://github.com/iryandae/Sisop-1-2024-MH-IT22/assets/150358232/bb7a61a3-6892-4e44-97a2-938cb8c32592">

## Soal 4
