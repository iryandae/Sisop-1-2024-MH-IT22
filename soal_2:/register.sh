#!/bin/bash
enc_user_password() {
echo -n "$1" | base64
}

user_regis() {
    local email=$1
    local username=$2
    local secure_q=$3
    local secure_a=$4
    local password=$5
    local user_type="user" 

duplicate_email() {
    local email=$1
    grep -q "^$email:" account.txt
    return $?
}


if [[ "$email" == admin ]]; then
        user_type="admin"
    fi

enc_user_password=$(enc_user_password "$password")
duplicate_email "$email"
    if [ $? -eq 0 ]; then
        echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [Regitration Failed] Email $email already registered." >> auth.log
        echo "Email $email already registered. Please enter another email."
        exit 1
    fi

echo "$email:$username:$secure_q:$secure_a:$enc_user_password:$user_type" >> account.txt

    if [[ $user_type == "admin" ]]; then
        echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [Registration Succeed] ADMIN $username registered successfully." >> auth.log
        echo "ADMIN $username registered successfully."
    else
        echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [Registration Succeed] User $username registered successfully." >> auth.log
        echo "User $username registered successfully."
    fi
}

#MAIN MENU
echo "===== Registration ====="
read -p "Email: " email
read -p "Username: " username
read -p "Security Question: " secure_q
read -p "Security Answer: " secure_a
read -sp "Password: " password
echo
while true; do
    if [[ ${#password} -lt 8 || !("$password" =~ [[:lower:]]) || !("$password" =~ [[:upper:]]) || !("$password" =~ [0-9]) ]]; then
        echo "Password must be at least 8 characters, contain at least one uppercase, one lowercase, and one number."
        read -sp "Password: " password
        echo
    else
        break
    fi
done

user_regis "$email" "$username" "$secure_q" "$secure_a" "$password"
