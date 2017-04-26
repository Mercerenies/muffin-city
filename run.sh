#!/bin/bash

if [ -z "$1" ]; then
    ./main.tcl
else
    (cat "$1" && cat) | ./main.tcl
fi
