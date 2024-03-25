#!/bin/bash
decrypt_user_password() {
    echo "$1" | base64 -d
}

check_credentials() {
    local email=$1
    local password=$2
    local saved_password=$(grep "^$email:" account.txt | cut -d: -f5)
    local is_admin=$(grep "^$email:" account.txt | cut -d: -f6)

saved_decrypt_password=$(decrypt_user_password "$saved_password")

    if [ "$password" == "$saved_decrypt_password" ]; then
        return 0
    else
        return 1
    fi
}

forgot_password() {
    local email=$1
    local secure_q=$(grep "^$email:" aacount.txt | cut -d: -f3)
    local correct_answer=$(grep "^$email:" account.txt | cut -d: -f4)

    read -p "Security Question: $secure_q" user_answer
if [ "$user_answer" == "$correct_answer" ]; then
        local saved_password=$(grep "^$email:" account.txt | cut -d: -f5)
        saved_decrypt_password=$(decrypt_user_password "$saved_password")
        echo "Your password is: $saved_decrypt_password"
    else
        echo "Incorrect answer."
    fi
}

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
            ./edit_user.sh
            ;;
        3)
            ./delete_user.sh
            ;;
        *)
            echo "Invalid action"
            ;;
esac
}

#MAIN MENU
echo "===== Login ====="
echo "1. Login"
echo "2. Forgot Password"
read -p "Choose option: " option

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

            if [[ $email == "admin" ]]
                then
                admin_actions
else
                echo "Login successful! No admin privileges."
            fi
        else
            echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [LOGIN FAILED] ERROR: Incorrect password for $email." >> auth.log
            echo "ERROR: Incorrect password."
            read -p "Forgot Password? (Y/N): " choice
            if [ "$choice" == "Y" ]; then
                forgot_password "$email"
            fi
        fi
        ;;
    2)
        read -p "Enter your email: " email
        forgot_password "$email"
        ;;
    *)
        echo "Invalid option"
        ;;
esac
