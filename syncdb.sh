#!/bin/bash


# check arguments
if [ $# -lt 1 ]; then
    echo 'Not enough arguments. For help type "--help"'
    exit
elif [ $1 = "--help" ]; then
    cat <<EOL
Script imports DB from hosting-mysql.ds-mz.local to local DB. Usage:

    ./syncdb -n db_name -u db_user -p db_pass -a (import|export)

EOL
    exit
fi

DB_NAME=
DB_USER=
DB_PASS=
ACTION='import'

# handle arguments
for (( i = 1, j = 2; i < $#; i++, j++ )); do
    KEY=${!i}
    VAL=${!j}
    case $KEY in
        -n)
            DB_NAME="$VAL"
            ;;
        -u)
            DB_USER="$VAL"
            ;;
        -p)
            DB_PASS="$VAL"
            ;;
        -a)
            ACTION="$VAL"
            ;;
    esac
done

if [[ -z "$DB_NAME" ]] || [[ -z "$DB_USER" ]] || [[ -z "$DB_PASS" ]]; then
    echo 'Not enough arguments. For help type "--help"'
    exit
fi

if [[ $ACTION == 'export' ]]; then
    mysqldump -u root "$DB_NAME" | mysql -h hosting-mysql.ds-mz.local -u "$DB_USER" -p"$DB_PASS" "$DB_NAME"
else
    mysqldump -h hosting-mysql.ds-mz.local -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" | mysql -u root "$DB_NAME"
fi