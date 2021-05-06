#!/bin/bash

IFS=$'\n' STRINGS=($(awk -F= 'NF <= 1 {next} {print $1}' Stripe/Resources/Localizations/en.lproj/Localizable.strings))

EXIT_CODE=0
HAS_INVALID_FORMAT=0
for VAL in "${STRINGS[@]}"
do
    ESCAPED_VAL=$(echo "$VAL" | sed 's/'\''/\\'"'"'/g')
    if [[ $ESCAPED_VAL =~ \\\(.*\) ]]
    then
        EXIT_CODE=1
        HAS_INVALID_FORMAT=1
        echo -e "\t\033[0;31m$ESCAPED_VAL\033[0m"
    fi
done

if [ $HAS_INVALID_FORMAT == 0 ]
then
    echo -e "\t\033[0;32mAll good!\033[0m"
else
    echo -e "\t\033[0;31m$Found invalid formatting.\033[0m"
fi

exit $EXIT_CODE
