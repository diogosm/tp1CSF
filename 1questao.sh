!#/bin/bash

## testo o outro rasp

ipServer="192.168.12.4"

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
	echo "realizando questao 1-d e 1-e"

	echo ""
	echo "inicializando..."
	sshpass -p 'raspberry' ssh -o StrictHostKeyChecking=no pi@$ipServer pkill iperf
	pkill iperf
	rm -f *.out
else
	exit 1
fi

## 1a parte

## executo comando no server rasp (192.168.12.4)
sshpass -p 'raspberry' ssh -o StrictHostKeyChecking=no pi@$ipServer "iperf -s" &
sleep 5

echo "rodando client..."
for i in `seq 1 10`;
do
	iperf -c $ipServer > saida1d-$i.out
done


## 2a parte 
echo "executando 2a parte..."

sshpass -p 'raspberry' ssh -o StrictHostKeyChecking=no pi@$ipServer pkill iperf
sshpass -p 'raspberry' ssh -o StrictHostKeyChecking=no pi@$ipServer "iperf -s -u -i 1" &
sleep 5

aux="m"
for j in `seq 3 10`;
do
	for i in `seq 1 10`;
	do
		iperf -c $ipServer -u -b $j$aux > saida1e-$j$aux-$i.out
	done
done

mkdir -p questao1logs
mv saida1* questao1logs/

echo "[FINISHED]";
