#!/bin/bash

for terminfo in xterm screen; do
    tic "$(dirname $(realpath $0))/terminfos/$terminfo-256color-italic.terminfo"
done
