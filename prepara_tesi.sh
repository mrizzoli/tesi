#!/bin/bash
set -e  # Fail on errors
set -x  # Verbosity all the way

# get token
## da sistemate usando variabili criptate in .travis.yml

### curl https://bitbucket.org/site/oauth2/access_token -d grant_type=client_credentials -u bSNv6FyLLwsr7jMzC7:pT3TAGUVcBBqMqyhD5BCEcwDTnvmg8kc

## Crea repo da bitbucket
##mkdir -p markdown
##git clone https://mrizzoli@bitbucket.org/mrizzoli/tesi.git markdown/

## Setta variabili e percorsi

origine=$PWD
temporanea=$PWD/"tmp"
dest=$PWD/"Chapters"

##concatena file md con note, uno per uno
mkdir -p ${temporanea}
mkdir -p ${dest}

cd ${origine}/"markdown"

for file in Chapter*
do
    echo "copio "$file" in "$temporanea""
    cat "$file" note.md >> ${temporanea}/$file
done

##esporta in latex

cd ${temporanea}

for file in *
do
    echo "esporto in latex "$file""
    pandoc --biblatex --chapters -o ${dest}/$file.tex $file
done

##cambia dir in /tesi/latex

cd ${dest}

for file in *
do
    mv $file ${file%%.*}.tex
done

##xelatex

cd ${origine}
xelatex template_tesi.tex

git remote set-url origin https://mrizzoli:${GH_TOKEN}@github.com/mrizzoli/tesi.git
git add *.pdf
git commit -m "update pdf"
git push origin master
