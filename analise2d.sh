#!/bin/bash

dir=("2questaoLogTemp70cm10m" "2questaoLogTemp70cm15m/2questao.sh-0.7" "2questaoLogTemp120cm10m/2questao.sh-1.2" "2questaoLogTemp2m10m/2questao.sh-2")

for d in ${dir[*]}; do
    count=0;
    totalLatencia=0;
    totalRec=0;
    totalEnviados=0;
    echo "_________________________________________________________________"
    echo "Diretorio :" $d
    for filename in $d/saida2d-*.out; do
        #echo $filename
        s="$(cat $filename | grep rtt | tr -s ' ' | cut -d' ' -f4 | cut -d'/' -f2 | bc -l)"
        e="$(cat $filename |  grep loss | tr -s ' ' | cut -d' ' -f1 | bc -l)"
        p="$(cat $filename |  grep loss | tr -s ' ' | cut -d' ' -f4 | bc -l)"  
        if [ -z "$s" ]; then
          echo $filename "nao tem dados"
        else
          totalLatencia=$(echo $totalLatencia+$s | bc )
          totalEnviados=$(echo $totalEnviados+$e | bc)
          totalRec=$(echo $totalRec+$p | bc)
          ((count++))
        fi
        
        #cat $filename |  grep "loss" | tr -s ' ' | cut -d' ' -f4

    done

    echo "Latencia  Media em ms"
    echo "scale=4; $totalLatencia / $count" | bc
    echo "Perda em %"
    echo "scale=2; (($totalEnviados - $totalRec) / $totalEnviados)*100" | bc
    echo "_________________________________________________________________"
done

