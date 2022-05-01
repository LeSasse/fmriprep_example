#!/usr/bin/bash
#############################################################################
#############################################################################


subj=${1}


#############################################################################
#############################################################################
# Set up environment


code=$(pwd)

#
# FMRIPREP
#
N_CPUS=1
#FMRIPREP=${code}/../fmriprep-21.0.2.simg
FMRIPREP=/data/project/singularity/fmriprep-20.2.0.simg

#
# Freesurfer
#
echo "Loading Freesurfer!"
module load freesurfer/7.1
echo "FREESURFER_HOME=${FREESURFER_HOME}"
license=/opt/freesurfer/7.1/license.txt

#
# dataset
# 
REPO=https://github.com/OpenNeuroDatasets/ds000102.git
export INPUT_DIR=$(mktemp -d)
export DERIVS=${code}/../derivatives
WORK_DIR=$(mktemp -d)

echo "INPUT_DIR=${INPUT_DIR}"
echo "DERIVATIVES=${DERIVS}"


#############################################################################
#############################################################################
# get data


datalad clone ${REPO} ${INPUT_DIR}
cd ${INPUT_DIR}
datalad get ${subj}


#############################################################################
#############################################################################
# run container


singularity run --cleanenv \
    -B ${WORK_DIR} \
    -B ${INPUT_DIR} \
    -B ${DERIVS} \
    -B ${license}:/opt/freesurfer/license.txt \
        ${FMRIPREP} \
        --n_cpus ${N_CPUS} \
        --skull-strip-fixed-seed \
        --work-dir ${WORK_DIR} \
        ${INPUT_DIR} ${DERIVS} participant \
        --participant-label ${subj}




