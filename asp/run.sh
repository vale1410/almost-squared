#!/bin/bash

#Option='--threads 4 --stat '
Option='--stat '

Strategy=$2
case $Strategy in
    0) Option=$Option'--heuristic=Berkmin --berk-max=163';;
    1) Option=$Option'--restarts=100,1.5,1000 --local-restart --save-progress';;
    2) Option=$Option'--heuristic=VSIDS';;
    3) Option=$Option'--deletion=1,1,1 --reduce-on-restart';;
    4) Option=$Option' --heu=VSIDS --sat-pre=20,25,120 --trans-ext=dynamic --loops=no --loops-in-heu=0';;
    5) Option=$Option'--restarts=100,1.5,1000 --save-progress';;
    6) Option=$Option'--otfs=1 --recursive-str --reverse-arcs=2 --sat-pre=20,25,120,-1,2';; 7) Option=$Option'--sat-pre=20,25,120';;
    8) Option=$Option'--sat-pre=20,25,120 --trans-ext=dynamic --backprop';;
    9) Option=$Option'--heu=VSIDS --sat-pre=20,25,120 --trans-ext=dynamic';;
    10) Option=$Option'--restarts=256 --save-progress';;
    11) Option=$Option'--heu=VSIDS --sat-pre=20,25,120 --trans-ext=integ';;
    12) Option=$Option'--restarts=16000';;
    13) Option=$Option'--sat-pre=20,25,120 --trans-ext=dynamic --initial-look=10 --restarts=no --recursive-str';;
    14) Option=$Option'--restarts=100,1.5,1000 --local-restart';;
    15) Option=$Option'--heuristic=Berkmin --berk-max=512';;
    16) Option=$Option'--dinit=800,10000 --dsched=5000,1.1 --deletion=3,1.1,10000';;
    17) Option=$Option'--sat-pre=20,25,120 --trans-ext=dynamic --initial-look=10 --restarts=no --recursive-str';;
    18) Option=$Option'--restarts=256 --local-restart';;
    19) Option=$Option'--eq=20 --backprop';;
    20) Option=$Option'--heuristic=Berkmin --berk-max=512 --berk-huang';;
    21) Option=$Option'--restarts=256';;
    22) Option=$Option'--restarts=256 --local-restart --save-progress';;
    23) Option=$Option'--heuristic=Bekmin --berk-ma';;
    24) Option=$Option'--restarts=100,1.5,1000';;
    25) Option=$Option'--restart-on-model -r 64 --heu=Vsids --opt-heu ';;
    26) Option=$Option'--restart-on-model --save-progress -r 32 --heu=Vsids ';;
    27) Option=$Option'--restart-on-model -r 4 --heuristic=Vsids --opt-heu ';;
esac

echo new try instance $1 >> output.txt
echo configuration: $Option    >> output.txt
gringo model.lp --const n=$1 | clasp --time-limit=$3 $Option | tee output.txt 
