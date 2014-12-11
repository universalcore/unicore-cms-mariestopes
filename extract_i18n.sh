#!/bin/bash
find . -name '*.mo' -delete
mkdir -p unicorecmsskeleton/locale

pot-create -o unicorecmsskeleton/locale/unicorecmsskeleton.pot unicorecmsskeleton/

declare -a arr=("eng_GB")

for lang in "${arr[@]}"
do
    mkdir -p "unicorecmsskeleton/locale/""$lang""/LC_MESSAGES"

    if [ ! -f "unicorecmsskeleton/locale/""$lang""/LC_MESSAGES/unicorecmsskeleton.po" ]; then
        msginit -l $lang -i unicorecmsskeleton/locale/unicorecmsskeleton.pot -o unicorecmsskeleton/locale/$lang/LC_MESSAGES/unicorecmsskeleton.po
    fi

    msgmerge --update unicorecmsskeleton/locale/$lang/LC_MESSAGES/unicorecmsskeleton.po unicorecmsskeleton/locale/unicorecmsskeleton.pot
    msgfmt unicorecmsskeleton/locale/$lang/LC_MESSAGES/*.po -o unicorecmsskeleton/locale/$lang/LC_MESSAGES/unicorecmsskeleton.mo
done
