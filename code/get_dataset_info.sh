#!/usr/bin/zsh

PROJECT_DIR=$(pwd)/../.

ds=$(mktemp -d)

datalad clone https://github.com/OpenNeuroDatasets/ds000102.git ${ds}

cd ${ds}

datalad get participants.tsv
datalad get dataset_description.json
datalad get T1w.json
datalad get task-flanker_bold.json

ls | grep sub- > subjects.txt
mv subjects.txt ${PROJECT_DIR}/submits

mv participants.tsv ${PROJECT_DIR}
mv dataset_description.json ${PROJECT_DIR}
mv T1w.json ${PROJECT_DIR}
mv task-flanker_bold.json ${PROJECT_DIR}

cd ${PROJECT_DIR}
datalad remove ${ds}

