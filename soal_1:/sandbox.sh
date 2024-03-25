#!/bin/bash

echo "top sales customer: "
sort -t, -k17,17nr Sandbox.csv  | cut -d, -f6 | head -n 1
echo -e "\n"

echo "least profit: "
sort -t, -k20,20 Sandbox.csv | cut -d, -f7 | head -n 1
echo -e "\n"

echo "profitable categories: "
awk -F',' '{arr[$14]+=$20} END {for (i in arr) print i, arr[i]}' Sandbox.csv | sed '3d'
echo -e "\n"

echo "enter name to search: "
read search
no_baris=$(grep -n -i "$search" Sandbox.csv | cut -d: -f1)
echo -e "\ndata found\n"
echo "purchase date: "
cut -d, -f2 Sandbox.csv | head -"$no_baris" | tail -n 1
echo "amount: "
cut -d, -f18 Sandbox.csv | head -"$no_baris" | tail -n 1
