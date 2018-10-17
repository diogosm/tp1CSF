#!/bin/bash

count=0;
totalBanda=0;
totalLoss=0;
for i in 3 4 5 6 7 8 9 10 ; do
#for i in 8 ; do
    count=0;
    totalBanda=0;
    totalLoss=0;
    p=0;
    e=0;
    echo "Largura de Banda em $i Mbits/sec"
        for filename in questao1logs/saida1e-$i*.out; do
            #echo $filename
            #cat $filename | sed -n '8p' | tr -s ' ' | cut -d' ' -f7
            #s="$(cat $filename | sed -n '8p' | tr -s ' ' | cut -d' ' -f7)"
            s="$(cat $filename | tail -n1 | tr -s ' ' | cut -d' ' -f7)"

	    ## trata kbits/sec
	    trataKbits="$(cat $filename | tail -n1 | tr -s ' ' | cut -d' ' -f8)"

	    if [ $trataKbits == "Kbits/sec" ];
	    then
		    s=$(echo $s*0.001 | bc -l)
	    fi

            totalBanda=$(echo $totalBanda+$s | bc )

	    #echo "$s $totalBanda Mbits"

            s1="$(cat $filename | tail -n1 | tr -s ' ' | cut -d' ' -f11 | cut -d'/' -f1 )"
            s2="$(cat $filename | tail -n1 | tr -s ' ' | cut -d' ' -f12)"
            #echo "  TTT" $s1
            p=$(echo $p+$s1 | bc )
            e=$(echo $e+$s2 | bc )
            #totalLoss=$(echo $totalLoss+$s3 | bc )
             ((count++))
        done
        echo "Largura de Banda  Media em Mbits/sec"
        echo "scale=2; $totalBanda / $count" | bc
        echo "Perda Media em % de datagrams"
        #echo "$p e $e"
        echo "scale=10; $p / $e" | bc
        echo " "
done
