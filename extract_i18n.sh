#!/bin/bash
find . -name '*.mo' -delete
mkdir -p unicorecmsmariestopes/locale

pot-create -o unicorecmsmariestopes/locale/unicorecmsmariestopes.pot unicorecmsmariestopes/

declare -a arr=("eng_GB")

for lang in "${arr[@]}"
do
    mkdir -p "unicorecmsmariestopes/locale/""$lang""/LC_MESSAGES"

    if [ ! -f "unicorecmsmariestopes/locale/""$lang""/LC_MESSAGES/unicorecmsmariestopes.po" ]; then
        msginit -l $lang -i unicorecmsmariestopes/locale/unicorecmsmariestopes.pot -o unicorecmsmariestopes/locale/$lang/LC_MESSAGES/unicorecmsmariestopes.po
    fi

    msgmerge --update unicorecmsmariestopes/locale/$lang/LC_MESSAGES/unicorecmsmariestopes.po unicorecmsmariestopes/locale/unicorecmsmariestopes.pot
    msgfmt unicorecmsmariestopes/locale/$lang/LC_MESSAGES/*.po -o unicorecmsmariestopes/locale/$lang/LC_MESSAGES/unicorecmsmariestopes.mo
done
