#!/bin/bash

count=0;
total=0;

for filename in questao1logs/saida1d-*.out; do
    s="$(cat $filename | tail -n1 | tr -s ' ' | cut -d' ' -f7)"
    total=$(echo $total+$s | bc )
     ((count++))
done
echo "Media em Mbits/sec"
echo "scale=2; $total / $count" | bc
