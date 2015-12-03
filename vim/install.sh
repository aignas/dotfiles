#!/bin/bash

VIM_DATA=${HOME}/.vim

echo "Create a directory for NeoBundle"
mkdir -p ${VIM_DATA}/bundle

echo "Create backup, swp and undo directories"
mkdir -p ${VIM_DATA}/{backup,swp,undo}
