#!/bin/bash

#DIR=${1:-./}
#CLUSTER_DIR=${2:-cluster}

DIR="results"
CLUSTER_DIR="tsne_cluster"

DIRECTORIES=$(find "$DIR" -regextype sed -regex "${DIR}/*${CLUSTER_DIR}_[0-9]*" -type d)

while read -r C_DIR
do
    echo 
    echo "$C_DIR"

    FILES=$(find "$C_DIR" -maxdepth 1 -mindepth 1 -name "*png" -type f -printf "%f\n") 

    TOTAL=$(echo "$FILES" | wc -l)
    CLASS_COUNT=$(echo "$FILES" | cut -d'_' -f2 | cut -d'.' -f1 | sort | uniq -c | tr -s ' ' | cut -d' ' -f2-)

    echo "$CLASS_COUNT" | while read -r LINE
    do
        NUM=$(echo ${LINE} | cut -d' ' -f1)
        CLASS=$(echo ${LINE} | cut -d' ' -f2)
        echo "$(echo "scale=2;($NUM/$TOTAL)*100" | bc -l)% ${CLASS}"
    done

done <<< "$DIRECTORIES"
