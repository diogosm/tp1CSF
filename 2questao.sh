!#/bin/bash

## testo o outro rasp
## usage:
##	./2questao altura distancia

ipServer="192.168.12.4"
altura=$0
distancia=$1

contador=10
while [[ $contador -ne 0 ]]; do
	ping -c 1 $ipServer
	ans=$?
	if [[ $ans -eq 0 ]]; then
		((contador=1))
	fi
	((contador = contador - 1))	
done

if [[ $ans -eq 0 ]]; then
	echo "rasp ok"
	echo "realizando questao 2"

	echo ""
	echo "inicializando..."
	sshpass -p 'raspberry' ssh -o StrictHostKeyChecking=no pi@$ipServer pkill iperf
	pkill iperf
	#rm -f *.out
else
	exit 1
fi

## 1a parte

## executo comando no server rasp (192.168.12.4)
sshpass -p 'raspberry' ssh -o StrictHostKeyChecking=no pi@$ipServer "iperf -s" &

echo "rodando client..."
for i in `seq 1 10`;
do
	ping -c 100 -i .1 $ipServer > saida2d-$i.out
	ping -c 100 -s 1400 -i .1 $ipServer > saida2e-$i.out
	ping -c 100 -s 8192 -i .1 $ipServer > saida2f-$i.out
	iperf -c $ipServer -t60 -i 1 > saida2g-$i.out
done


## 2a parte 
	
sshpass -p 'raspberry' ssh -o StrictHostKeyChecking=no pi@$ipServer pkill iperf
sshpass -p 'raspberry' ssh -o StrictHostKeyChecking=no pi@$ipServer "iperf -s -u -l 56.0b" &

aux="m"
for j in `seq 3 10`;
do
	for i in `seq 1 10`;
	do
		iperf -c $ipServer -u -l 56.0b -t 60 -i 1 -b $j$aux > saida2h-$j$aux-$i.out
	done
done

mkdir -p questao2logs
mv saida2* questao1logs/

echo "[FINISHED]";
