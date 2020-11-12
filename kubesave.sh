#!/usr/bin/env bash

###
# Project name: kubesave.sh 
# Description: this script is meant to save your kubernetes objects, separated in yaml files
# Author: Eduardo Lisboa <eduardo.lisboa@gmail.com>
# Date: 30/05/2020

# Variables
export OBJECT
export OBJECT_item
export NAMESPACE
export COMMAND

# Checking environment tools
for COMMAND in mkdir kubectl
do
    echo -ne "Checking for command ${COMMAND}: "
    if command -v "${COMMAND}" >& /dev/null
    then
        echo "SUCCESS"
    else
        echo "FAILED! ${COMMAND} not found. Exitting now"
        exit 1
    fi
done

# Core part
for OBJECT in deploy service secret configmap ingress HorizontalPodAutoscaler PersistentVolumeClaim
do

    for NAMESPACE in $(kubectl get namespaces | grep -v ^NAME | awk '{print $1}')
    do
        echo -e "Checking namespace ${NAMESPACE}"
        if mkdir -pv "${NAMESPACE}"
        then
            echo "Directory ${PWD}/${NAMESPACE} created sucessfully"
            for OBJECT_item in $(kubectl -n "${NAMESPACE}" get "${OBJECT}" | grep -v ^NAME | awk '{print $1}')
            do
                echo -ne "Saving $OBJECT on ${PWD}/${NAMESPACE}/${OBJECT}-${OBJECT_item}.yaml file: "
                if kubectl -n "${NAMESPACE}" get "${OBJECT}" "${OBJECT_item}" -o yaml > "${NAMESPACE}/${OBJECT}-${OBJECT_item}.yaml"
                then
                    echo SUCCESS
                else
                    echo FAILED
                fi
            done
        else
            echo "Failed to create or access ${PWD}/${NAMESPACE} directory"
            exit 1
        fi
    done

done
